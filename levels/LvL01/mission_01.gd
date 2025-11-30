extends Node2D
@onready var mission_area: Label = $Player/Camera2D/CanvasLayer/Ui/MissionArea
@onready var dmg_timer: Timer = $World/LvlBound/DmgTimer
@onready var player: CharacterBody2D = $Player


var PlayerIsOutside = false

var DmgOutside:int = 10
var doDamageIntervall: float = 0.5
var DmgCounter = true

func _ready() -> void:
	dmg_timer.wait_time = doDamageIntervall
	mission_area.visible = false
	
func _process(_delta: float) -> void:
	if PlayerIsOutside == true and DmgCounter == true:
		player.take_damage(DmgOutside)
		DmgCounter = false
		dmg_timer.start()
		
func _on_dmg_timer_timeout() -> void:
	DmgCounter = true


func _on_lvl_bound_area_entered(_body) -> void:
	mission_area.visible = false
	PlayerIsOutside = false
	dmg_timer.stop()


func _on_lvl_bound_body_entered(_body) -> void:
	mission_area.visible = false
	PlayerIsOutside = false
	dmg_timer.stop()


func _on_lvl_bound_body_exited(_body) -> void:
	mission_area.visible = true
	PlayerIsOutside = true
	dmg_timer.start()
