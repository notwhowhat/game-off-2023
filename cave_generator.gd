extends Node

@export var map_width = 80
@export var map_height = 50

@export var world_seed = "hi"
@export var noise_octaves = 3
@export var noise_period = 3
@export var noise_persistence = 0.7
@export var noise_lacunarity = 0.4

@export var noise_threshold = 0.5
@export var redraw: bool:
	set(value):
		if self.tile_map == null:
			return
		clear()
		generate()

var tile_map: TileMap
var noise = FastNoiseLite.new()

func _ready():
	self.tile_map = get_parent() as TileMap
	clear()
	generate()

func clear():
	self.tile_map.clear()
	
func generate():
	self.noise.seed = self.world_seed.hash()
	self.noise.fractal_octaves = self.noise_octaves
	self.noise.fractal_weighted_strength = self.noise_persistence
	self.noise.fractal_lacunarity = self.noise_lacunarity
	
	for x in range(-self.map_width / 2, self.map_width / 2):
		for y in range(-self.map_height / 2, self.map_height / 2):
			var noise_pos = self.noise.get_noise_2d(x, y)
			if noise_pos < self.noise_threshold:
				self._set_tile(x, y, noise_pos)

func _set_tile(x, y, noise_pos):
	var pos = Vector2i(x, y)
	self.tile_map.set_cell(0, pos, 0, Vector2(0, randi() % 2))
	
