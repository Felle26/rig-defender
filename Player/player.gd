extends CharacterBody2D


const SPEED: float = 300.0
const ACCELERATION : float = 400.0
const FRICTION: float = 100.0


var can_fire_machine_gun = true
var mouse_speed := 20.0

@export var Bullet : PackedScene
@export var Fire_rate_timer: float = 0.1


@onready var timer: Timer = $Weapon/Timer
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var player_Sprite: Sprite2D = $Icon
@onready var muzzle_machine_gun: Marker2D = $Icon/Muzzle_machine_gun


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	timer.timeout.connect(_on_machine_gun_can_fire)

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
	
func _process(_delta):
	fire_weapon()
	controller_Input()
	player_Sprite.look_at(get_global_mouse_position())
	
	var max_distance := 100.0
	var dir := get_local_mouse_position().normalized()
	ray_cast_2d.target_position = dir * max_distance
	ray_cast_2d.force_raycast_update()
	
	
	
	
func controller_Input() -> void:
	
	var x := Input.get_joy_axis(0.0, 2 as JoyAxis)  # rechter Stick horizontal
	var y := Input.get_joy_axis(0.0, 3 as JoyAxis)  # rechter Stick vertikal

	if abs(x) > 0.1 or abs(y) > 0.1:
		var mouse_pos := get_viewport().get_mouse_position()
		mouse_pos += Vector2(x, y) * mouse_speed
		get_viewport().warp_mouse(mouse_pos)

func fire_weapon():
	var fire_ground: = false
	var fire_air: = false
	if Input.is_action_pressed("fire_ground") and can_fire_machine_gun:
		if fire_air == false:
			fire_round()
			can_fire_machine_gun = false
			fire_ground = true
			timer.wait_time = Fire_rate_timer
			timer.start()
			
		
			print_debug("test")
		
		
	
	if Input.is_action_just_released("fire_ground"):
		fire_ground = false
	
	if Input.is_action_pressed("fire_air") and can_fire_machine_gun:
		fire_round()
		if fire_ground == false:
			fire_air = true
			can_fire_machine_gun = false
			timer.wait_time = Fire_rate_timer
			timer.start()
		
		
	if Input.is_action_just_released("fire_air"):
		fire_air = false
	
func fire_round()-> void:
	var bullet = Bullet.instantiate()
	owner.add_child(bullet)
	bullet.transform = muzzle_machine_gun.global_transform
	
func _on_machine_gun_can_fire()-> void:
	can_fire_machine_gun = true
	
