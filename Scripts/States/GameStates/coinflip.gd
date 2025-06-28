extends State
class_name coinflip

var coin_flip: int

func enter():
	print ("===Coin Flip State Entered===")
	_coin_flip()

func _coin_flip():
#forcing player only for testing.
	#coin_flip = randi_range(0,1)
	coin_flip = 0
	
func update(_delta: float):
	if coin_flip == 0:
		Transitioned.emit(self, "playerturn")
	else:
		Transitioned.emit(self, "opponentturn")

func exit():
	print ("===Coin Flip State Exited===")
		
