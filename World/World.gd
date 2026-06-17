extends Node2D

@onready var tableN = $table
@onready var radarN = $radar
@onready var clothN = $cloth

func _ready() -> void:
	
	var table = tableN.build_table()
	GameEnvironment.TABLE = table
	tableN.print_table(table)
	
	print(" ")
	
	var radar = radarN.radar_map(table)
	GameEnvironment.RADAR = radar
	radarN.print_radar(radar)
	
	print(" ")
	
	clothN.test_region_finder(radar)
