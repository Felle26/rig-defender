extends Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var explosion: Sprite2D = $explosion
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var damage_area: Area2D = $damage_Area
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var explosion_timer: Timer = $Explosion_Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damage_area.monitoring = false
	

func hit() ->void:
	sprite_2d.visible = false
	explosion.visible = true
	animation_player.play("explosion")
	damage_area.monitoring = true
	explosion_timer.start()
	
	
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "explosion":
		
		queue_free()

func check_explosion_radius()->void:
	
	for body in damage_area.get_overlapping_bodies():
		if body.has_method("hit"):
			body.hit()
			
	for area in damage_area.get_overlapping_areas():
		if area.has_method("hit"):
			area.hit()


func _on_explosion_timer_timeout() -> void:
	check_explosion_radius()
