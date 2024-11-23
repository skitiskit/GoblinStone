extends State

#start state

func enter():
	#fetch saved games (not currently in) when start menu selection is made move to appropriate save
	pass

func start():
	Transitioned.emit(self, "mapstate")
	Global.goto_scene("res://Scenes/map_scene.tscn")
	
func quit():
	get_tree().quit()
	
func exit():
	pass
