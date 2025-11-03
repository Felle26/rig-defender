extends CharacterBody2D


const SPEED: float = 300.0
const ACCELERATION : float = 600.0
const FRICTION: float = 100.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	
		

	# Handle jump.
	var input_vector := Vector2.ZERO
	
	input_vector.y = Input.get_axis("up", "down")
	input_vector.x = Input.get_axis("left", "right")

	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		

	move_and_slide()
