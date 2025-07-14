extends playerstate
class_name playerturn

signal inventory_update

var player_dice: Array = PlayerData.player_inventory.duplicate(true)
var player_die: int
var player_name = "player"

func enter():
	print ("===Player Turn Entered===")
	#TODO enable inputs for the player on state enter
	turn_track.emit(player_name)
	touch_block.emit(false)
	await get_tree().create_timer(1.0).timeout
	toggle_action.emit()
	await board_updated(null)
	dice_roll(player_name,player_die,player_dice[0])
	
	
#understand board state transitions
#OPTIMIZE - logs shows board update player 3 times a turn, look into this (both player states) looks like boardupdate is listening in both states regardless of active state
func board_updated(end):
	print("board update player")
	if end == true:
		print("transitioned scoring")
		Transitioned.emit(self,"scoring")
	elif end == false:
		print("transitioned opponentturn")
		Transitioned.emit(self,"opponentturn")
	else:
		pass

func exit():
	print ("===Player Turn Exited===")
	inventory_update.emit()
	toggle_action.emit()
