extends State
class_name scoring

signal score_check

func enter():
	print("scoring")
	score_check.emit()

func next_round():
	Transitioned.emit(self,"coinflip")
	
func exit():
	pass
