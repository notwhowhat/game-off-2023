extends TileMap

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()
var width = 64
var height = 64

@onready var player = get_parent().get_child(1)

func _ready():
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()

func _process(delta):
	generate_chunk(player.position)
	
func generate_chunk(position):
	var tile_pos = local_to_map(position)
	for x in range(width):
		for y in range(height):
			var moist = moisture.get_noise_2d(tile_pos.x + x - width / 2, tile_pos.y + y - height / 2) * 10
			var temp = temperature.get_noise_2d(tile_pos.x + x - width / 2, tile_pos.y + y - height / 2) * 10
			var alt = altitude.get_noise_2d(tile_pos.x + x - width / 2, tile_pos.y + y - height / 2) * 10
			set_cell(0, Vector2i(tile_pos.x + x - width / 2, tile_pos.y + y - height / 2), 0, Vector2(0, (round((temp + 10) / 10))))
			if alt < 2:
				set_cell(0, Vector2i(tile_pos.x + x - width / 2, tile_pos.y + y - height / 2), 0, Vector2(0, (round((temp + 10) / 10))))
			else:
				set_cell(0, Vector2i(tile_pos.x + x - width / 2, tile_pos.y + y - height / 2), 0, Vector2(0, (round((temp + 10) / 5))))

func clear_chunk(tile_pos):
	for x in range(width):
		for y in range(height):
			set_cell(0, Vector2i(tile_pos.x + x - width / 2, tile_pos.y + y - height / 2), -1, Vector2(-1, -1))
			

func dist(p1, p2):
	var r = p1 - p2
	return sqrt(r.x ** 2 + r.y ** 2)
