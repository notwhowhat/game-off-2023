extends TileMap

signal spawn_mob(pos)

@onready var player = get_node("../Player")

@export var map_width = 80
@export var map_height = 50
@onready var noise = FastNoiseLite.new()
var prev_gen_tile_coords = {}

func _ready():
	noise.seed = randi()
	noise.fractal_octaves = 8
	noise.fractal_weighted_strength = 0.7
	noise.fractal_lacunarity = 0.4
	#self.noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.03
	generate()#Vector2(-1000, 100))

func generate(pos=Vector2(0, 0)):
	# to start with, fish will only be able to spawn on un-generated tiles.
	var tmap_pos
	var map_pos = local_to_map(pos)
	for x in range(map_width):
		for y in range(map_height):
			var noise_pos
			var new_tile = false
			var tile_pos = Vector2i(map_pos.x + x - map_width / 2, map_pos.y + y - map_height / 2)
			if tile_pos in prev_gen_tile_coords:
				# reuses the previously generated tile for performance
				noise_pos = prev_gen_tile_coords.get(tile_pos)
				new_tile = false
			else: 
				# makes a new tile
				noise_pos = noise.get_noise_2d(tile_pos.x, tile_pos.y)
				prev_gen_tile_coords[tile_pos] = noise_pos
				new_tile = true
				
				
			if not round(int(noise_pos + 10) % 2):
				# stone/wall
				tmap_pos = Vector2(0, 0)
			else:
				# water
				tmap_pos = Vector2(0, 1)  
				if new_tile:
					# maybe spawn a fish
					if randi() % 10 == 1:
						print(tile_pos)
						spawn_mob.emit(tile_pos)
						new_tile = false
				
				
			_set_tile_map(tile_pos, tmap_pos)
			#_set_tile(tile_pos.x, tile_pos.y, noise_pos)
				
			#var noise_pos = self.noise.get_noise_2d(tile_pos.x, tile_pos.y)
			#if noise_pos < self.noise_threshold:
				#self._set_tile(x + x - pos.x, y + y - pos.y, noise_pos)
			#_set_tile(tile_pos.x, tile_pos.y, noise_pos)
				#print(pos.x)
			#else:
			#	self._set_tile(map_pos.x + x - map_width / 2, map_pos.y + y - map_height / 2, noise_pos)

func _set_tile(x, y, noise_pos):
	var pos = Vector2i(x, y)
	set_cell(0, pos, 0, Vector2(0, round(int(noise_pos + 10) % 2)))

func _set_tile_map(tile_pos, tmap_pos):
	set_cell(0, tile_pos, 0, tmap_pos)

func _on_player_redraw():
	#clear()
	generate(player.position)
