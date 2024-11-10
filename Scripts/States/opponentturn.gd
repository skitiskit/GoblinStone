extends playerstate
class_name opponentturn

signal opponent_action

#TODO FIX THIS SHIT, figure out where you're defining the opponents die pool per stage and manage it here.
var opponent_dice: Array = PlayerData.player_inventory.duplicate(true)
var opponent_die: int
var player_name = "opponent"

func enter():
	turn_track.emit(player_name)
	await Game._turn_track()
	toggle_action.emit()
	
	dice_roll(player_name,opponent_die,opponent_dice[0])

	opponent_action.emit()
	
func board_updated(end):
	print("board update")
	if end == true:
		exit()
		print("transitioned scoring")
		Transitioned.emit(self,"scoring")
	else:
		exit()
		print("transitioned playerturn")
		Transitioned.emit(self,"playerturn")

func exit():
	pass
