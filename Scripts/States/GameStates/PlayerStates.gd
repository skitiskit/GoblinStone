extends State
class_name playerstate

signal update_die(player, die)
signal turn_track(player)
signal toggle_action(player)

func dice_roll(player, player_die, player_dice):
	var dice_type = Dice.get(player_dice)
	player_die = dice_type.pick_random()
	print("dice roll " + player, " ", player_die, " ", player_dice, " ", dice_type)
	update_die.emit(player,player_die)

