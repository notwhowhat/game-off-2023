extends CharacterBody2D

signal spawn_mob

@export var speed = 1500
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	velocity.x = Input.get_axis("move_left", "move_right")
	velocity.y = Input.get_axis("move_up", "move_down")
	velocity = velocity.normalized() * speed
	move_and_slide()
	
	
func _process(delta):
	if Input.is_action_just_released("spawn_mob"):
		spawn_mob.emit()
		
