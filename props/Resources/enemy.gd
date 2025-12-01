extends CharacterBody2D

@export var data: EnemyData
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var explosion_sound: AudioStreamPlayer2D = $Explosion_Sound
@onready var fire_sound: AudioStreamPlayer2D = $Fire_Sound
@onready var player_direction: RayCast2D = $Player_direction
@onready var fire_rate_Timer: Timer = $Fire_rate
@onready var bullet_spawner: Marker2D = $Player_direction/Bullet_Spawner
@onready var enemy_sprite: AnimatedSprite2D = $enemy_sprite
@onready var move_timer: Timer = $moveTimer


@export var Fire_Rate: float = .2
@export var bullet: PackedScene

@export var Healthdrop: PackedScene
@export var Rocketdrop: PackedScene

@export var moveSpeed: float = 50.0
var move_direction: Vector2 = Vector2.ZERO

var is_destroyed: bool
var can_Fire: bool
var player_is_in_range :bool
var player



var current_health

func _ready() -> void:
	is_destroyed = false
	can_Fire = true
	player_is_in_range = false
	fire_rate_Timer.wait_time = data.fire_rate
	
	player = get_parent().find_child("Player")
	current_health = data.health
	progress_bar.max_value = data.health
	progress_bar.value = current_health
	
	#movement
	move_timer.wait_time = 2.0
	move_timer.start()
	
func _physics_process(delta: float) -> void:
	if is_destroyed == false:
		_aim()
		_fire_at_player()
		_random_move(delta)
		_update_animation()

func hit(dmg: int) -> void:
	if current_health > dmg:
		current_health -= dmg
		_update_health_Bar()
	else:
		is_destroyed = true
		progress_bar.value = 0
		progress_bar.visible = false
		animation_player.play("explosion")
		enemy_sprite.visible = false
		explosion_sound.play()
		_SpawnDrop()
	
func _update_health_Bar() -> void:
	progress_bar.value = current_health


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "explosion":
		queue_free()
		
func _fire_at_player() -> void:
	if player_is_in_range == true and can_Fire == true:
		var fired_bullet = bullet.instantiate()
		fired_bullet.damage = data.dmg_amount
		fired_bullet.global_position = bullet_spawner.global_position
		fired_bullet.direction = (player_direction.target_position).normalized()
		owner.add_child(fired_bullet)
		fire_sound.play()
		can_Fire = false
		fire_rate_Timer.start()
		



func _on_range_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		player_is_in_range = true




func _on_range_body_exited(body: Node2D) -> void:
	if body.has_method("take_damage"):
		player_is_in_range = false


func _aim() ->void:
	if player_is_in_range == true:
		player_direction.target_position = to_local(player.position)


func _on_fire_rate_timeout() -> void:
	can_Fire = true
	
	#movement
func _random_move(_delta: float) -> void:
	velocity = move_direction * moveSpeed
	move_and_slide()
	


func _on_move_timer_timeout() -> void:
	move_direction = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()
	
func _update_animation() -> void:
	if move_direction == Vector2.ZERO:
		enemy_sprite.play("Idle0")
		return
	var dir = move_direction.normalized()
	
	if dir.y < -0.5:
		if dir.x < -0.5:
			enemy_sprite.play("Idle5")
		elif dir.x > 0.5:
			enemy_sprite.play("Idle7")
		else:
			enemy_sprite.play("Idle6")
	elif dir.y > 0.5:
		if dir.x < -0.5:
			enemy_sprite.play("Idle3")
		elif dir.x > 0.5:
			enemy_sprite.play("Idle1")
		else:
			enemy_sprite.play("Idle2")
	else:
		if dir.x < -0.5:
			enemy_sprite.play("Idle4")
		elif dir.x > 0.5:
			enemy_sprite.play("Idle0")
			
func _SpawnDrop() -> void:
	var dropActive = false
	if dropActive == false:
		dropActive = true
		var randomNumber: int = 0
		randomNumber = randi_range(0,4)
		if randomNumber == 1: #healthdrop
			var drop = Healthdrop.instantiate()
			drop.global_position = global_position
			get_parent().call_deferred("add_child", drop)
		elif randomNumber == 2:

			var drop = Rocketdrop.instantiate()
			drop.global_position = global_position
			get_parent().call_deferred("add_child", drop)
		else:
			return
