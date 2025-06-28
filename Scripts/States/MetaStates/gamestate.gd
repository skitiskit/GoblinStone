extends State

#player is in a match
func enter():
	print ("===Game State Entered===")
	Global.goto_scene("res://Scenes/game.tscn")
	#TODO are there functions I should run on enter of the gamestate?
	

func exit():
	print ("===Game State Exited===")
