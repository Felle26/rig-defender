extends Control
@onready var exit: Button = $VBoxContainer/EXIT
@onready var settings: Button = $VBoxContainer/Settings
@onready var start_game: Button = $"VBoxContainer/Start Game"

@onready var LevelScreen = "res://levels/MissionScreen/MissionScreen.tscn"




func _on_exit_pressed() -> void:
	queue_free()


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file(LevelScreen)
