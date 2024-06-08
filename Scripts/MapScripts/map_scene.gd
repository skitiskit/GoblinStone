extends Control

func _on_status_menu_pressed():
	$StatusPanel.visible = !$StatusPanel.visible
	$StatusPanel/HP.text = "HP: " + str(Global.player_hp)
	
func _on_quit_pressed():
	get_tree().quit()

func _on_level_1_pressed():
	Global.goto_scene("res://Scenes/game.tscn")


func _on_level_2_pressed():
	Global.goto_scene("res://Scenes/game.tscn")


func _on_level_3_pressed():
	Global.goto_scene("res://Scenes/game.tscn")


func _on_level_4_pressed():
	Global.goto_scene("res://Scenes/game.tscn")


func _on_level_5_pressed():
	Global.goto_scene("res://Scenes/game.tscn")
