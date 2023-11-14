extends TileMap

#var moisture = FastNoiseLite.new()
#var temperature = FastNoiseLite.new()
#var altitude = FastNoiseLite.new()
var whole_map = FastNoiseLite.new()
var width = 1920
var height = 108

@onready var player = get_parent().get_child(1)

func _ready():
	whole_map.seed = randi()
	whole_map.noise_type = FastNoiseLite.TYPE_PERLIN
	whole_map.frequency = 0.009
	whole_map.fractal_octaves = 8 # 5
	whole_map.fractal_lacunarity = 1.65 #2.345
	whole_map.fractal_gain = 0.795 #0.54
	whole_map.fractal_weighted_strength = 0.78


func _process(delta):
	generate_chunk(player.position)
	
func generate_chunk(position):
	var tile_pos = local_to_map(position)
	for x in range(width):
		for y in range(height):
			var map = whole_map.get_noise_2d(tile_pos.x + x - width / 2, tile_pos.y + y - height / 2) * 10
			set_cell(0, Vector2i(tile_pos.x + x - width / 2, tile_pos.y + y - height / 2),
					 0, Vector2(0, (round((map + 10) / 10))))
			#set_cell(0, Vector2i(tile_pos.x + x - width / 2, tile_pos.y + y - height / 2),
			#		 0, Vector2(0, 0))
			#set_cell()
			
			
			
			
