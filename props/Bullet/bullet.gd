extends Area2D

var speed = 400
@export var bullet_dmg: int


func _ready() -> void:
	var timer = Timer.new()
	timer.wait_time = 0.4
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	set_process(true)
	print_debug(bullet_dmg)
	
	
	

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	
func _on_timer_timeout()->void:
	queue_free()
	


func _on_area_entered(area: Area2D) -> void:
	_do_damage(area)
	print_debug("area_entered")

func _do_damage(target:Node)->void:
	if target.has_method("hit") and (target.is_in_group("enemy") or target.is_in_group("enemy_barrel")):
		target.hit(bullet_dmg)
		queue_free()
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	_do_damage(body)
	print_debug("Body_entered")
