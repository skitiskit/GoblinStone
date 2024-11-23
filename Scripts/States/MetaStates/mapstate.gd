extends State

#player is on the map until they select a path
#need to sort out updating UI on ENTER (which paths are open, any HUD elements like HP)
#refresh the Status modal? or should I do that when it's called?

#pass a var to indicate which scene to load when path is selected

func enter():
	Global.connect("gamestate", start)
	
func start(level):
	print(level)
	Transitioned.emit(self, "gamestate")
	

func exit():
	Global.goto_scene("res://Scenes/game.tscn")
