extends playerstate
class_name playerturn


var player_dice: Array = PlayerData.player_inventory.duplicate(true)
var player_die: int
var player_name = "player"

func enter():
	#TODO enable inputs for the player on state enter
	turn_track.emit(player_name)
	toggle_action.emit()
	
	dice_roll(player_name,player_die,player_dice[0])
	
	

func board_updated(end):
	print("board update")
	if end == true:
		exit()
		print("transitioned scoring")
		Transitioned.emit(self,"scoring")
	else:
		exit()
		print("transitioned opponentturn")
		Transitioned.emit(self,"opponentturn")

func exit():
	#TODO disable inputs for the player on state exit
	pass
