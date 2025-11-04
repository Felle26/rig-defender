extends CharacterBody2D


const SPEED: float = 300.0
const ACCELERATION : float = 400.0
const FRICTION: float = 100.0

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var player_Sprite: Sprite2D = $Icon

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	
	var input_vector := Vector2.ZERO
	
	input_vector.y = Input.get_axis("up", "down")
	input_vector.x = Input.get_axis("left", "right")

	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		

	move_and_slide()
	
func _process(delta):
	player_Sprite.look_at(get_global_mouse_position())
	
	var max_distance := 100.0
	var dir := get_local_mouse_position().normalized()
	ray_cast_2d.target_position = dir * max_distance
	ray_cast_2d.force_raycast_update()
