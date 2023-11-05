extends CharacterBody2D

@export var speed = 1500
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	velocity.x = Input.get_axis("ui_left", "ui_right")
	velocity.y = Input.get_axis("ui_up", "ui_down")
	velocity = velocity.normalized() * speed
	move_and_slide()
	
	
