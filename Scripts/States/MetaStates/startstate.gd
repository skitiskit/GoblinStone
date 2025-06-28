extends State

#start state

func enter():
	#TODO fetch saved games (not currently in) when start menu selection is made move to appropriate save
	print ("===Start State Entered===")
	Global.connect("mapstate", start)

func start():
	Transitioned.emit(self, "mapstate")
	
	
func quit():
	get_tree().quit()
	
func exit():
	print ("===Start State Exited===")
	Global.goto_scene("res://Scenes/map_scene.tscn")
