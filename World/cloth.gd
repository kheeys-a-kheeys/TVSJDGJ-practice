extends Node2D

# logic related to obscuring the radar and table

# dimensions are inputs since this runs before the table is even generated
func obscuring_cloth(width: int, heigt: int) -> Array:
	
	var cloth = []
	cloth.resize(width)
	
	for i in width:
		var column = []
		column.resize(heigt)
		column.fill(0)
		cloth[i] = column.duplicate()
	
	return cloth

func test_region_finder(radar: Array) -> void:
	var zoning = find_regions(radar)
	for i in zoning[0].size():
		var row = []
		for j in zoning.size():
			row.append(zoning[j][i])
		print(row)

# use connected-component labeling to find regions instead of the batshit recursion I tried before
# based on this guide: https://www.youtube.com/watch?v=ticZclUYy88
func find_regions(radar: Array) -> Array:
	
	# collapse the radar input
	var zoning = radar.duplicate(true)
	for i in radar[0].size():
		for j in radar.size():
			if radar[j][i] != 0:
				zoning[j][i] = -1
	
	var zones = [0]
	var zones_equiv_list = [0]
	
	# now the first raster
	for i in zoning[0].size():
		for j in zoning.size():
			
			var up = Vector2i(0, -1) + Vector2i(j, i)
			var lf = Vector2i(-1, 0) + Vector2i(j, i)
			
			# we'll have to pretend out-of-bounds points to a -1
			# be aware, the booleans are about to get fucky
			# the real solution is to just shift the matrix by (1,-1) but that's no fun
			var up_zone
			if (up.y < 0): # out of bounds
				up_zone = (zoning[j][i] == -1)
			else: # determine if NOT in mine radius
				up_zone = (zoning[up.x][up.y] != -1)
			# now again for the left-pointer
			var lf_zone
			if (lf.x < 0):
				lf_zone = (zoning[j][i] == -1)
			else:
				lf_zone = (zoning[lf.x][lf.y] != -1)
			
			if (zoning[j][i] == 0):
				# "new" zone found
				if (!up_zone && !lf_zone): # either at (0, 0), or outside mine radius
					zones.append(zones.size())
					zones_equiv_list.append(zones_equiv_list.size())
					zoning[j][i] = zones.size() - 1
				else: # it's a connected zone and COULD be on EITHER boundary (but NOT both at once!)
					var zone_min
					var zone_max
					if (up.y < 0 || lf.x < 0): # if on boundary
						zone_min = -1
						if (up.y < 0): # if boundary is above
							zone_max = maxi(-1, (zoning[lf.x][lf.y]))
						else: # boundary is to the left
							zone_max = maxi(zoning[up.x][up.y], -1)
					else: # we are safe
						zone_min = mini(zoning[up.x][up.y], (zoning[lf.x][lf.y]))
						zone_max = maxi(zoning[up.x][up.y], (zoning[lf.x][lf.y]))
					
					# but it could be WITHIN a zone (or two)
					if (zone_min != -1):
						zoning[j][i] = zone_min
						# should two zones intersect, replace the index in the equiv_list
						if (zone_min != zone_max): 
							zones_equiv_list[zone_max] = zones_equiv_list[zone_min]
					else: # it's at a zone edge
						zoning[j][i] = zone_max
	
	# now the second raster to properly group everything
	for i in zoning[0].size():
		for j in zoning.size():
			zoning[j][i] = zones_equiv_list[maxi(zoning[j][i], 0)]
	
	return zoning
