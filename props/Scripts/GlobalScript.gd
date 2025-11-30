extends Node

var mission_01_passed: bool = false
var mission_02_passed: bool = false
var mission_03_passed: bool = false

var missionData = {}
var missionDataPath = "res://levels/Missions.json"

var Objectives = load("res://levels/Missions.json")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var cursor := load("res://textures/Crosshair.png")
	var hotspot := Vector2(cursor.get_width() / 2, cursor.get_height() / 2)
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, hotspot)
	missionData = load_mission_Json(missionDataPath)


# Called every frame. 'delta' is the elapsed time since the previous frame.


func set_mission_01_passed() -> void:
	mission_01_passed = true
	
func set_mission_02_passed() -> void:
	mission_02_passed = true
	
func set_mission_03_passed() -> void:
	mission_03_passed = true


func load_mission_Json(filepath: String):
	if FileAccess.file_exists(filepath):
		var DataFile = FileAccess.open(filepath,FileAccess.READ)
		var parsedResult = JSON.parse_string(DataFile.get_as_text())
		
		if parsedResult is Dictionary:
			return parsedResult
		else:
			print("Data Parsing Error")
	else:
		print("Mission Data Corrupted")
		
