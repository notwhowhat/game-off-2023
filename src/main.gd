extends Node

@export var fish_scene: PackedScene

@onready var player = $Player
@onready var noise = $CaveMap.noise

func _ready():
	#spawn_mob()
	print(noise.get_noise_2d(player.position.x, player.position.y))
	print(noise.get_noise_2d(player.position.x, player.position.y) * 10 + 1 % 2)
	#while noise.get_noise_2d(player.position.x, player.position.y) * 10 + 1 % 2 > 0:
	while round(int(noise.get_noise_2d(player.position.x, player.position.y) + 10)) % 2 > 0:
		player.position.x += 1
		player.position.y += 1
		print(player.position)
	
func spawn_mob(move=false):
	# spawn a fish
	var fish = fish_scene.instantiate()
	
	if not move:
		fish.position = player.position
	else:
		var fish_spawn_location = get_node("FishPath/FishSpawnLocation")
		fish_spawn_location.progress_ratio = randf()
		var direction = fish_spawn_location.rotation + PI / 2
		
		fish.position = fish_spawn_location.position
		
		direction += randf_range(-PI / 4, PI / 4)
		fish.rotation = direction
		
		var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
		fish.linear_velocity = velocity.rotated(direction)
			
	add_child(fish)

	# todecide: should the fish be scaled to the player y when they spawn, or constantly,
	# so if you escape downwards they get bigger.

func _on_checkpoint_body_entered(body):
	#if body == player:
	print("check the point")

func _on_player_spawn_mob():
	spawn_mob()
