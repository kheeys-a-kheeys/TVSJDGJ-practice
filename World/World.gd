extends Node2D

@onready var tableN = $table
@onready var radarN = $radar
@onready var clothN = $cloth

@onready var TableG = $TableGraphic
@onready var ClothG = $ClothGraphic

# set our tablecloth when the game launches
func _ready() -> void:
	for i in tableN.Heigt:
		for j in tableN.Width:
			ClothG.set_cell(Vector2i(j, i), 2, Vector2i(0, 0))

func _process(float) -> void:
	if Input.is_action_just_released("select"):
		var mous = get_viewport().get_mouse_position()
		var mousT = Vector2i(floor(mous/16))
		print(mousT)
		if GameEnvironment.TABLE.is_empty():
			first_turn(mousT)
			reveal_region(mousT)
		else:
			reveal_region(mousT)
	
	if Input.is_action_just_released("placeFlag"):
		var mous = get_viewport().get_mouse_position()
		var mousT = Vector2i(floor(mous/16))
		if ClothG.get_cell_source_id(mousT) == 2:
			ClothG.set_cell(mousT, 1, Vector2i(0, 0))
		elif ClothG.get_cell_source_id(mousT) == 1:
			ClothG.set_cell(mousT, 2, Vector2i(0, 0))

# the first click starts the game
func first_turn(start: Vector2i) -> void:
	GameEnvironment.TABLE = tableN.build_table(start)
	GameEnvironment.RADAR = radarN.radar_map(GameEnvironment.TABLE)
	GameEnvironment.CLOTH = clothN.find_regions(GameEnvironment.RADAR)
	
	# seting the graphics
	var radar = GameEnvironment.RADAR
	var atlasC = Vector2i(0, 0)
	for i in radar[0].size():
		for j in radar.size():
			if radar[j][i] > 0 && radar[j][i] < 9:
				TableG.set_cell(Vector2i(j, i), radar[j][i] - 1, atlasC)
			elif radar[j][i] == 0:
				TableG.set_cell(Vector2i(j, i), 8, atlasC)
			else:
				TableG.set_cell(Vector2i(j, i), 9, atlasC)

# to determine if the tile we clicked is in a 0 region, and to flip accordingly
func reveal_region(target: Vector2i) -> void:
	var cloth = GameEnvironment.CLOTH
	var region = cloth[target.x][target.y]
	if region != 0:
		# we also want to reveal the leading edge of 0 regions
		var scanr = [Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1), 
					 Vector2i(-1, 0), Vector2i(1, 0), 
					 Vector2i(-1, 1), Vector2i(0, 1), Vector2i(1, 1)]
		
		for i in cloth[0].size():
			for j in cloth.size():
				var center = Vector2i(j, i)
				if cloth[j][i] == region:
					ClothG.set_cell(center)
				elif cloth[j][i] == 0: # tile COULD be next to the region
					# condition should prevent revealing of tiles from other regions
					for k in scanr.size():
						var scanp = center + scanr[k]
						var bindx = maxi(mini(scanp.x, cloth.size() - 1), 0)
						var bindy = maxi(mini(scanp.y, cloth[0].size() - 1), 0)
						if (bindx == scanp.x && bindy == scanp.y): # skip if out of bounds
							if cloth[scanp.x][scanp.y] == region:
								ClothG.set_cell(center)
	else:
		ClothG.set_cell(target)
