extends Area2D

var speed = 400


func _ready() -> void:
	var timer = Timer.new()
	timer.wait_time = 2
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	
	

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	

func _on_Bullet_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		explode_rocket($Area2D)
	queue_free()
	
	
func explode_rocket(target: Node)-> void:
	if target.has_method("hit") and (target.is_in_group("enemy") or target.is_in_group("enemy_barrel")):
		target.hit()
		queue_free()
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	explode_rocket(area)

func _on_area_2d_body_entered(body: Node2D) -> void:
	explode_rocket(body)

func _on_timer_timeout()->void:
	explode_rocket($Area2D)
