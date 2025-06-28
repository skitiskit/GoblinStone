extends State
class_name scoring

signal score_check
signal board_reset

func enter():
	print("===Scoring State Entered===")
	score_check.emit()

func next_round():
	Transitioned.emit(self,"coinflip")

#TODO when the game is over, need to send a signal up to the meta state manager to flip from the game state
#to the reward state
func game_over():
	Transitioned.emit(self,"rewardstate")
	
#TODO should look to do some board clean up on exit from scoring probably
func exit():
	print("===Scoring State Exited===")
	board_reset.emit()
