extends Control


@onready var startMission: Button = $HBoxContainer/Button2

@onready var MainMenuScene = "res://levels/TitleScreen/Title Screen.tscn"
@onready var mission_01: TextureButton = $Mission_01
@onready var mission_02: TextureButton = $Mission_02
@onready var mission_03: TextureButton = $Mission_03

@onready var mission_name: Label = $VBoxContainer/MissionName
@onready var flavor_text: RichTextLabel = $VBoxContainer/FlavorText
@onready var goals: RichTextLabel = $VBoxContainer/Goals


var currentSelectedMission: String = "LvL00"

@export var LvL01: PackedScene
@export var LvL02: PackedScene
@export var LvL03: PackedScene

var currentSelectedLevelToLoad

func _ready() -> void:
	startMission.disabled = true
	_setMissionEmpty(currentSelectedMission)
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file(MainMenuScene)


func _on_mission_03_pressed() -> void:
	if currentSelectedMission == "LvL03":
		currentSelectedMission = "LvL00"
		_setMissionEmpty(currentSelectedMission)
		startMission.disabled = true
	else:
		currentSelectedMission = "LvL03"
		mission_01.button_pressed = false
		mission_02.button_pressed = false
		startMission.disabled = false
		currentSelectedLevelToLoad = LvL03
		_setMissionStats(currentSelectedMission)
		_setMissionEmpty(currentSelectedMission)
	

func _on_mission_02_pressed() -> void:
	if currentSelectedMission == "LvL02":
		currentSelectedMission = "LvL00"
		_setMissionEmpty(currentSelectedMission)
		startMission.disabled = true
	else:
		currentSelectedMission = "LvL02"
		mission_01.button_pressed = false
		mission_03.button_pressed = false
		startMission.disabled = false
		currentSelectedLevelToLoad = LvL02
		_setMissionStats(currentSelectedMission)
		_setMissionEmpty(currentSelectedMission)

func _on_mission_01_pressed() -> void:
	if currentSelectedMission == "LvL01":
		currentSelectedMission = "LvL00"
		_setMissionEmpty(currentSelectedMission)
		startMission.disabled = true
	else:
		currentSelectedMission = "LvL01"
		mission_02.button_pressed = false
		mission_03.button_pressed = false
		startMission.disabled = false
		currentSelectedLevelToLoad = LvL01
		_setMissionStats(currentSelectedMission)
		_setMissionEmpty(currentSelectedMission)

func _setMissionStats(currentMission: String):
	mission_name.text = GlobalScript.missionData[currentMission]["title"]
	flavor_text.text = GlobalScript.missionData[currentMission]["Sitation"]
	goals.text = GlobalScript.missionData[currentMission]["Goal"]

func _setMissionEmpty(currentMission: String ):
	if currentMission == "LvL00":
		mission_name.text = "---"
		flavor_text.text = "Select a Mission to Start"
		goals.text = "At the moment, only one mission can be played."
		currentSelectedMission = "LvL00"


func _onStartMissionPressed() -> void:
	get_tree().change_scene_to_packed(currentSelectedLevelToLoad)
