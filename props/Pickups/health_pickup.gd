extends Area2D

@export var HealthGain: int = 25


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("UpdateHealth"):
		body.UpdateHealth(HealthGain)
		queue_free()
