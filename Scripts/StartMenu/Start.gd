extends Control

func _on_start_pressed():
	Global.emit_signal("mapstate")
	
func _on_quit_pressed():
	get_tree().quit()
