extends Area2D

var speed = 400

@onready var damage_radius: Area2D = $Damage_Radius
@onready var collision_shape_2d: CollisionShape2D = $Damage_Radius/CollisionShape2D
@onready var explosion_sound: AudioStreamPlayer = $AudioStreamPlayer

@export var Dmg_radius: PackedScene

func _ready() -> void:
	var timer = Timer.new()
	timer.wait_time = 2
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(_timeout_explode)
	add_child(timer)
	
	

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	
func _timeout_explode()-> void:
	queue_free()

	
func explode_rocket(target: Node)-> void:
	damage_radius.set_deferred("monitorable", true)
	damage_radius.set_deferred("monitoring", true)
	if target.has_method("hit") and (target.is_in_group("enemy") or target.is_in_group("enemy_barrel")):
		explosion_sound.play()
		target.hit()
		queue_free()
	queue_free()



#Area Functions
func _on_body_entered(body: Node2D) -> void:
	explode_rocket(body)


func _on_area_entered(area: Area2D) -> void:
	explode_rocket(area)


func _on_damage_radius_area_entered(area: Area2D) -> void:
	explode_rocket(area)
	print("area entered")


func _on_damage_radius_body_entered(body: Node2D) -> void:
	explode_rocket(body)
	print("body entered")


func _on_gpu_particles_2d_2_finished() -> void:
	queue_free()
