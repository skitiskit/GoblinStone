extends State

#player is on the map until they select a path
#TODO need to sort out updating UI on ENTER (which paths are open, any HUD elements like HP)
#refresh the Status modal? or should I do that when it's called?

#pass a var to indicate which scene to load when path is selected

func enter():
	print ("===Map State Entered===")
	reset()
	Global.connect("gamestate", start)
	
func start(level):
	levelscale(level)
	Transitioned.emit(self, "gamestate")
	
func levelscale(level):
	print("levelscale invoked")
	if level == "level1":
		print(OpponentData.opponent_hp)
		pass
	elif level == "level2":
		OpponentData.opponent_hp += 10
		print(OpponentData.opponent_hp)
		pass
	elif level == "level3":
		OpponentData.opponent_hp += 20
		print(OpponentData.opponent_hp)
		pass
	elif level == "level4":
		OpponentData.opponent_hp += 30
		print(OpponentData.opponent_hp)
		pass
	else:
		OpponentData.opponent_hp += 50
		print(OpponentData.opponent_hp)
		pass
	
	#HACK this look to be a function I hacked in to level set the opponent and deck
func reset():
	OpponentData.opponent_hp = 100
	OpponentData.opponent_inventory = ["d6","d6","d6","d6","d6","d6","d6","d6","d6"]
	

func exit():
	print ("===Map State Exited===")
	pass
