extends Area2D
@export var rockets: int = 4



func _on_body_entered(body: Node2D) -> void:
	if body.has_method("updateRockets"):
		body.updateRockets(rockets)
		queue_free()
