extends playerstate
class_name playerturn


var player_dice: Array = PlayerData.player_inventory.duplicate(true)
var player_die: int
var player_name = "player"

func enter():
	#TODO enable inputs for the player on state enter
	turn_track.emit(player_name)
	await get_tree().create_timer(1.0).timeout
	toggle_action.emit()
	await board_updated(null)
	dice_roll(player_name,player_die,player_dice[0])
	
	
#understand board state transitions
func board_updated(end):
	print("board update")
	if end == true:
		exit()
		print("transitioned scoring")
		Transitioned.emit(self,"scoring")
	elif end == false:
		exit()
		print("transitioned opponentturn")
		Transitioned.emit(self,"opponentturn")
	else:
		pass

func exit():
	#TODO disable inputs for the player on state exit
	pass
