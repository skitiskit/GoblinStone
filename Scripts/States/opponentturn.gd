extends playerstate
class_name opponentturn

signal opponent_action

#TODO FIX THIS SHIT, figure out where you're defining the opponents die pool per stage and manage it here.
var opponent_dice: Array = PlayerData.player_inventory.duplicate(true)
var opponent_die: int
var player_name = "opponent"

func enter():
	turn_track.emit(player_name)
	await get_tree().create_timer(1.0).timeout
	toggle_action.emit()
	await board_updated(null)
	dice_roll(player_name,opponent_die,opponent_dice[0])
	await get_tree().create_timer(1.0).timeout
	opponent_action.emit()
	
func board_updated(end):
	print("board update")
	if end == true:
		exit()
		print("transitioned scoring")
		Transitioned.emit(self,"scoring")
	elif end == false:
		exit()
		print("transitioned playerturn")
		Transitioned.emit(self,"playerturn")
	else:
		pass

func exit():
	pass
