extends Control

func _on_start_pressed():
	Global.goto_scene("res://Scenes/map_scene.tscn")
	


func _on_quit_pressed():
	get_tree().quit()
