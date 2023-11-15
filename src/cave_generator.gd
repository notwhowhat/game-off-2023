extends Node

@onready var player = get_node("../Player")

@export var map_width = 80
@export var map_height = 50

@export var redraw: bool:
	set(value):
		if self.tile_map == null:
			return
		clear()
		generate()

var tile_map: TileMap
@onready var noise = FastNoiseLite.new()
var prev_gen_tile_coords = {}


func _ready():
	self.tile_map = get_parent() as TileMap
	self.noise.seed = randi()
	self.noise.fractal_octaves = 8
	self.noise.fractal_weighted_strength = 0.7
	self.noise.fractal_lacunarity = 0.4
	#self.noise.noise_type = FastNoiseLite.TYPE_PERLIN
	self.noise.noise_type = FastNoiseLite.TYPE_VALUE_CUBIC
	self.noise.frequency = 0.03
	
	#clear()
	generate()#Vector2(-1000, 100))

func clear():
	self.tile_map.clear()
	
func generate(pos=Vector2(0, 0)):
	
	var map_pos = tile_map.local_to_map(pos)
	
	for x in range(self.map_width):
		for y in range(self.map_height):
			var noise_pos
			var tile_pos = Vector2(map_pos.x + x - map_width / 2, map_pos.y + y - map_height / 2)
			if tile_pos in prev_gen_tile_coords:
				noise_pos = prev_gen_tile_coords.get(tile_pos)
			else: 
				noise_pos = self.noise.get_noise_2d(tile_pos.x, tile_pos.y)
				prev_gen_tile_coords[tile_pos] = noise_pos
			#var noise_pos = self.noise.get_noise_2d(tile_pos.x, tile_pos.y)
			#if noise_pos < self.noise_threshold:
				#self._set_tile(x + x - pos.x, y + y - pos.y, noise_pos)
			self._set_tile(tile_pos.x, tile_pos.y, noise_pos)
				#print(pos.x)
			#else:
			#	self._set_tile(map_pos.x + x - map_width / 2, map_pos.y + y - map_height / 2, noise_pos)
			
				
				
func _set_tile(x, y, noise_pos):
	var pos = Vector2i(x, y)
	#self.tile_map.set_cell(0, pos, 0, Vector2(0, int(noise_pos * 10) % 2))
	self.tile_map.set_cell(0, pos, 0, Vector2(0, round(int(noise_pos + 10) % 2)))
	#print(noise_pos)
	


func _on_player_redraw():
	#clear()
	generate(player.position)
