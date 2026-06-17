extends Node2D

# logic related to adjacency tiles

# function to increment adjacency tiles
func radar_map(table: Array) -> Array:
	
	var radar = table.duplicate(true)
	var scanr = [Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1), 
				 Vector2i(-1, 0), Vector2i(1, 0), 
				 Vector2i(-1, 1), Vector2i(0, 1), Vector2i(1, 1)]
	
	for i in table[0].size():
		for j in table.size():
			var center = Vector2i(j, i)
			var count = 0
			if (table[j][i] == 0): # if index at (j, i) does NOT have a mine
				for k in scanr.size():
					var scanp = center + scanr[k]
					var bindx = maxi(mini(scanp.x, table.size() - 1), 0)
					var bindy = maxi(mini(scanp.y, table[0].size() - 1), 0)
					if (bindx == scanp.x && bindy == scanp.y): # skip if out of bounds
						if (table[scanp.x][scanp.y] > 0): # if target index has a mine
							count += 1
				radar[j][i] = count
			else: # the index at (j, i) contains a mine
				radar[j][i] = 9
				count = 9
	
	return radar

# function for debugging radar map
func print_radar(radar: Array) -> void:
	for i in radar[0].size():
		var row = []
		for j in radar.size():
			row.append(radar[j][i])
		print(row)
