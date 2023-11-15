extends RigidBody2D

#@onready var scale = Vector2(1, 1)
@onready var player = get_node("../Player")

func _ready():
	var scaling = Vector2(player.position.y / 100, player.position.y / 100)
	#self.apply_scale()
	$Sprite.apply_scale(scaling)
	
	
