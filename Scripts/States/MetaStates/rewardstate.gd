extends State
class_name rewardstate

signal update_PlayerData
signal reward_display

#player ends a match, presented reward options
func enter():
	print ("===Reward State Entered===")
	_roll_rewards()

func _roll_rewards():
	#var reward1
	#var reward2
	#var reward3
	#TODO generate reward pool to be displayed/selected
	#reward_display.emit(reward1, reward2, reward3)
	pass

	
func exit():
	print ("===Reward State Exited===")
	#TODO save to playerdata
	update_PlayerData.emit()
