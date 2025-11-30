extends Sprite2D


@export var damage: int = 5
@export var Speed: float = 300
var direction: Vector2 = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	position += direction * Speed * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
