extends Control

@onready var level_status = {0:$Level1,1:$Level2,2:$Level3,3:$Level4,4:$Level5}

func _ready():
	for key in [0,1,2,3,4]:
		if key == PlayerData.player_progress:
			level_status[key].visible = !level_status[key].visible
	
func _on_status_menu_pressed():
	$StatusPanel.visible = !$StatusPanel.visible
	$StatusPanel/HP.text = "HP: " + str(PlayerData.player_hp)
	$StatusPanel/Wins.text = "Wins: " + str(PlayerData.wins)
	
func _on_quit_pressed():
	get_tree().quit()

#I think there's probably a better way to do this
func _on_level_1_pressed():
	Global.emit_signal("gamestate", "level1")

func _on_level_2_pressed():
	Global.emit_signal("gamestate", "level2")

func _on_level_3_pressed():
	Global.emit_signal("gamestate", "level3")

func _on_level_4_pressed():
	Global.emit_signal("gamestate", "level1")

func _on_level_5_pressed():
	Global.emit_signal("gamestate", "level1")
