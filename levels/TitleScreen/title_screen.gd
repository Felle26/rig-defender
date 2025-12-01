extends Control
@onready var exit: Button = $VBoxContainer/EXIT
@onready var settings: Button = $VBoxContainer/Settings
@onready var start_game: Button = $"VBoxContainer/Start Game"

@onready var LevelScreen = "res://levels/MissionScreen/MissionScreen.tscn"
@onready var thanks: Label = $Thanks




func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file(LevelScreen)

func _process(_delta: float) -> void:
	if GlobalScript.mission_01_passed == true:
		GlobalScript.mission_01_passed = false
		thanks.visible = true
