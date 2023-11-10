extends Node2D

@onready var tilemap = $TileMap
@onready var player = $Player

const MAP_SIZE = Vector2(128, 128) #Vector2(128, 128)
const LAND_CAP = 0.01

var loaded_chunks = []

func _ready():
	#var pos = tilemap.map_to_local(player.position)
	
	# the position altered by the players camera
	#generate_world()#pos)
	pass

func camera_pos(pos, x, y):
	return Vector2(pos.x + x - (MAP_SIZE.x / 2), pos.y + y - (MAP_SIZE.y / 2))
	
func generate_world(pos=Vector2(0, 0)):
	var noise = FastNoiseLite.new()
	noise.seed = 106
	
	var cells = []
	for x in MAP_SIZE.x:
		for y in MAP_SIZE.y:
			var cpos = camera_pos(pos, x, y)
			
			var a = noise.get_noise_2d(cpos.x, cpos.y)
			
			if a < LAND_CAP:
				cells.append(cpos)
			else:
				tilemap.set_cell(0, cpos, 1, Vector2(3, 0), 0)
			
	tilemap.set_cells_terrain_connect(0, cells, 0, 0)
