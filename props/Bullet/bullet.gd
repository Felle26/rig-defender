extends Area2D

var speed = 600

func _ready() -> void:
	var timer = Timer.new()
	timer.wait_time = 0.2
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	set_process(true)
	
	

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	

func _on_Bullet_body_entered(body: Node2D) -> void:
	if body. is_in_group("enemy"):
		body.queue_free()
	queue_free()
	
func _on_timer_timeout()->void:
	queue_free()
	
