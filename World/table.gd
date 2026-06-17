extends Node2D

# script to generate an arbitary table
# this could be a 2d array that is passed to a singleton (to be worked on graphics-side)

@export var Width = 10
@export var Heigt = 10

#func _ready() -> void:
	#var table = build_array()
	#table = bury_mines(table)
	#print(table.size())
	#print_table(table)

func build_table() -> Array:
	var table = build_array()
	table = bury_mines(table)
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
