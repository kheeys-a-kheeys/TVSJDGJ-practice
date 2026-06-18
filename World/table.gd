extends Node2D

# script to generate an arbitary table
# this could be a 2d array that is passed to a singleton (to be worked on graphics-side)

@export var Width = 10
@export var Heigt = 10

func build_table(safe_point: Vector2i) -> Array:
	
	var table = build_array()
	table = bury_mines(table)
	
	table[safe_point.x][safe_point.y] = 0
	# let's also ensure the area around the starting point is safe...
	var sweep = [Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1), 
				 Vector2i(-1, 0), Vector2i(1, 0), 
				 Vector2i(-1, 1), Vector2i(0, 1), Vector2i(1, 1)]
	for k in sweep.size():
		var targe = safe_point + sweep[k]
		var bindx = maxi(mini(targe.x, table.size() - 1), 0)
		var bindy = maxi(mini(targe.y, table[0].size() - 1), 0)
		if (bindx == targe.x && bindy == targe.y): # skip if out of bounds
			table[targe.x][targe.y] = 0
	
	return table

# to visualize the table for debugging
func print_table(table: Array) -> void:
	for i in table[0].size():
		var row = []
		for j in table.size():
			row.append(table[j][i])
		print(row)

# create an empty array
func build_array() -> Array:
	
	var table = []
	table.resize(Width)
	
	for i in Width:
		var column = []
		column.resize(Heigt)
		table[i] = column.duplicate() # not sure if deep duplicate would be necessary
	
	return table

# randomly placing mines
# this should generate a (more-or-less) uniform distribution that we can use to place monsters
func bury_mines(table: Array) -> Array:
	
	var rng = RandomNumberGenerator.new()
	
	for i in table[0].size():
		for j in table.size():
			# roll 3d6, iunno
			var place_check = rng.randi_range(1, 6) + rng.randi_range(1, 6) + rng.randi_range(1, 6)
			if place_check < 8: # we can vary this as an export later (call it density)
				table[j][i] = 1
				#print("mine placed at: ", i, " ", j)
			else:
				table[j][i] = 0
	
	return table
