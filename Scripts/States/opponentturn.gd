extends playerstate
class_name opponentturn

signal opponent_action

#TODO FIX THIS SHIT, figure out where you're defining the opponents die pool per stage and manage it here.
var opponent_dice: Array = PlayerData.player_inventory.duplicate(true)
var opponent_die: int
var player_name = "opponent"

func enter():
	dice_roll(player_name,opponent_die,opponent_dice[0])
	turn_track.emit(player_name)
	toggle_action.emit(player_name)
	
func board_update(end):
	print("board update")
	if end == true:
		exit()
		Transitioned.emit(self,"scoring")
	else:
		exit()
		Transitioned.emit(self,"playerturn")
		
