extends State
class_name scoring

signal score_check

func enter():
	print("scoring")
	score_check.emit()

func next_round():
	Transitioned.emit(self,"coinflip")

#TODO when the game is over, need to send a signal up to the meta state manager to flip from the game state
#to the reward state
func game_over():
	pass
	
#TODO should look to do some board clean up on exit from scoring probably
func exit():
	pass
