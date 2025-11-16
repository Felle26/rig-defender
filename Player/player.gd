extends CharacterBody2D


const SPEED: float = 300.0
const ACCELERATION : float = 400.0
const FRICTION: float = 100.0


var can_fire_machine_gun = true
var can_fire_rockets = true
var mouse_speed := 20.0
#rocket settings
var current_rocket_count : int = 10
var rockets_left_fire: bool = true
var current_animation: String

@export var Rocket : PackedScene
@export var Bullet : PackedScene
@export var Fire_rate_timer: float = 0.1 #for Bullets
@export var Rocket_fire_rate_timer: float = 2.0 #for Rockets

@onready var rocket_timer: Timer = $Weapon/Rocket_timer
@onready var timer: Timer = $Weapon/Timer
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var player_Sprite: AnimatedSprite2D = $Icon
@onready var fire_direction: Node2D = $Fire_direction

#Audio Stream Player
@onready var rocket_fire: AudioStreamPlayer = $Audio_Files/Rocket_start
@onready var machine_gun: AudioStreamPlayer = $Audio_Files/MachineGun



@onready var muzzle_machine_gun: Marker2D = $Fire_direction/Muzzle_machine_gun
@onready var rocket_marker_left: Marker2D = $Fire_direction/Rocket_marker_left
@onready var rocket_marker_right: Marker2D = $Fire_direction/Rocket_marker_right


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	timer.timeout.connect(_on_machine_gun_can_fire)
	rocket_timer.timeout.connect(_on_Rocket_can_fire)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	current_animation = "Idle"
	
	
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
	#player_Sprite.look_at(get_global_mouse_position())
	
	var max_distance := 100.0
	var dir := get_local_mouse_position().normalized()
	#Fire Direction Rotation
	fire_direction.rotation = dir.angle()
	ray_cast_2d.target_position = dir * max_distance
	ray_cast_2d.force_raycast_update()
	
	
	#Calculation for Sprite Animation
	var angle = snappedf(dir.angle(), PI/4) / (PI/4)
	angle = wrapi(int(angle),0,8)
	player_Sprite.animation = current_animation + str(angle)
	
	
	
	
func controller_Input() -> void:
	
	var x := Input.get_joy_axis(0.0, 2 as JoyAxis)  # rechter Stick horizontal
	var y := Input.get_joy_axis(0.0, 3 as JoyAxis)  # rechter Stick vertikal

	if abs(x) > 0.1 or abs(y) > 0.1:
		var mouse_pos := get_viewport().get_mouse_position()
		mouse_pos += Vector2(x, y) * mouse_speed
		get_viewport().warp_mouse(mouse_pos)

func fire_weapon():
	
	if Input.is_action_pressed("fire_ground") and can_fire_machine_gun:
		fire_round()
		machine_gun.play()
		can_fire_machine_gun = false
		timer.wait_time = Fire_rate_timer
		timer.start()
	
	if Input.is_action_pressed("fire_air") and can_fire_rockets:
		fire_rocket()
		rocket_fire.play()
		can_fire_rockets = false
		rocket_timer.wait_time = Rocket_fire_rate_timer
		rocket_timer.start()

func fire_round()-> void:
	var bullet = Bullet.instantiate()
	owner.add_child(bullet)
	bullet.transform = muzzle_machine_gun.global_transform

func fire_rocket()->void:
	var rocket = Rocket.instantiate()
	owner.add_child(rocket)
	if rockets_left_fire:
		rocket.transform = rocket_marker_left.global_transform
		rockets_left_fire = false
	else:
		rocket.transform = rocket_marker_right.global_transform
		rockets_left_fire = true
	
	
func _on_machine_gun_can_fire()-> void:
	can_fire_machine_gun = true

func _on_Rocket_can_fire()-> void:
	can_fire_rockets = true
