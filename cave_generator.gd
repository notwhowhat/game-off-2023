extends Node

@onready var player = get_node("../../Player")

@export var map_width = 80
@export var map_height = 50

@export var world_seed = randi()
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
	#clear()
	generate()#Vector2(-1000, 100))

func clear():
	self.tile_map.clear()
	
func generate(pos=Vector2(0, 0)):
	self.noise.seed = self.world_seed
	self.noise.fractal_octaves = self.noise_octaves
	self.noise.fractal_weighted_strength = self.noise_persistence
	self.noise.fractal_lacunarity = self.noise_lacunarity
	self.noise.noise_type = FastNoiseLite.TYPE_PERLIN
	
	var map_pos = tile_map.local_to_map(pos)
	
	#for x in range(-self.map_width / 2, self.map_width / 2):
	#	for y in range(-self.map_height / 2, self.map_height / 2):
	for x in range(self.map_width):
		for y in range(self.map_height):
			var noise_pos = self.noise.get_noise_2d(map_pos.x + x - map_width / 2, map_pos.y + y - map_height / 2)
			#if noise_pos < self.noise_threshold:
				#self._set_tile(x + x - pos.x, y + y - pos.y, noise_pos)
			self._set_tile(map_pos.x + x - map_width / 2, map_pos.y + y - map_height / 2, noise_pos)
				#print(pos.x)
			#else:
			#	self._set_tile(map_pos.x + x - map_width / 2, map_pos.y + y - map_height / 2, noise_pos)
				
				
func _set_tile(x, y, noise_pos):
	var pos = Vector2i(x, y)
	#self.tile_map.set_cell(0, pos, 0, Vector2(0, int(noise_pos * 10) % 2))
	self.tile_map.set_cell(0, pos, 0, Vector2(0, round(int(noise_pos + 10) % 2)))
	#print(noise_pos)
	


func _on_player_redraw():
	clear()
	generate(player.position)
