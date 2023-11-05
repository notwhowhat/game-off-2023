extends Node2D

@onready var tilemap = $TileMap

const MAP_SIZE = Vector2(8, 8) #Vector2(128, 128)
const LAND_CAP = 0.1

func _ready():
	generate_world(MAP_SIZE, LAND_CAP)
	
func generate_world(map_size, land_cap):
	var noise = FastNoiseLite.new()
	noise.seed = 100
	
	var global_pos = tilemap.map_to_local()
	
	var cells = []
	for x in MAP_SIZE.x:
		for y in map_size.y:
			var a = noise.get_noise_2d(x, y)
			var b = noise.get_noise_2d(x + global_pos.x, y + global_pos.y)
			if a < land_cap:
				cells.append(Vector2(x, y))
			else:
				tilemap.set_cell(0, Vector2(x, y), 1, Vector2(3, 0), 0)
				
	#tilemap.set_cells_terrain_connect(0, cells, 0, 0)
	tilemap.set_cells_terrain_connect(0, cells, 0, 0)
	

	
