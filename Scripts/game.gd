extends Control

#board dictionaries
@onready var playerBoardState = {"A1":0,
	"B1":0,
	"C1":0,
	"A2":0,
	"B2":0,
	"C2":0,
	"A3":0,
	"B3":0,
	"C3":0}
@onready var playerBoardDice = {"A1":"empty",
	"B1":"empty",
	"C1":"empty",
	"A2":"empty",
	"B2":"empty",
	"C2":"empty",
	"A3":"empty",
	"B3":"empty",
	"C3":"empty"}
@onready var oppBoardState = {"A1":0,
	"B1":0,
	"C1":0,
	"A2":0,
	"B2":0,
	"C2":0,
	"A3":0,
	"B3":0,
	"C3":0}
@onready var playerBoardButtons = {
	"A1":$PlayerBoard/Board/A1/Button,
	"B1":$PlayerBoard/Board/B1/Button,
	"C1":$PlayerBoard/Board/C1/Button,
	"A2":$PlayerBoard/Board/A2/Button,
	"B2":$PlayerBoard/Board/B2/Button,
	"C2":$PlayerBoard/Board/C2/Button,
	"A3":$PlayerBoard/Board/A3/Button,
	"B3":$PlayerBoard/Board/B3/Button,
	"C3":$PlayerBoard/Board/C3/Button }
@onready var playerBoardSprites = {
	"A1":$PlayerBoard/Board/A1/Button/dicesprite,
	"B1":$PlayerBoard/Board/B1/Button/dicesprite,
	"C1":$PlayerBoard/Board/C1/Button/dicesprite,
	"A2":$PlayerBoard/Board/A2/Button/dicesprite,
	"B2":$PlayerBoard/Board/B2/Button/dicesprite,
	"C2":$PlayerBoard/Board/C2/Button/dicesprite,
	"A3":$PlayerBoard/Board/A3/Button/dicesprite,
	"B3":$PlayerBoard/Board/B3/Button/dicesprite,
	"C3":$PlayerBoard/Board/C3/Button/dicesprite }
@onready var oppBoardButtons = {
	"A1":$OpponentBoard/Board/A1/Button,
	"B1":$OpponentBoard/Board/B1/Button,
	"C1":$OpponentBoard/Board/C1/Button,
	"A2":$OpponentBoard/Board/A2/Button,
	"B2":$OpponentBoard/Board/B2/Button,
	"C2":$OpponentBoard/Board/C2/Button,
	"A3":$OpponentBoard/Board/A3/Button,
	"B3":$OpponentBoard/Board/B3/Button,
	"C3":$OpponentBoard/Board/C3/Button }
@onready var oppBoardSprites = {
	"A1":$OpponentBoard/Board/A1/Button/dicesprite,
	"B1":$OpponentBoard/Board/B1/Button/dicesprite,
	"C1":$OpponentBoard/Board/C1/Button/dicesprite,
	"A2":$OpponentBoard/Board/A2/Button/dicesprite,
	"B2":$OpponentBoard/Board/B2/Button/dicesprite,
	"C2":$OpponentBoard/Board/C2/Button/dicesprite,
	"A3":$OpponentBoard/Board/A3/Button/dicesprite,
	"B3":$OpponentBoard/Board/B3/Button/dicesprite,
	"C3":$OpponentBoard/Board/C3/Button/dicesprite }
@onready var playerInvSprites = {
	0:$GridContainer/Panel/Button/dicesprite,
	1:$GridContainer/Panel2/Button/dicesprite,
	2:$GridContainer/Panel3/Button/dicesprite,
	3:$GridContainer/Panel4/Button/dicesprite,
	4:$GridContainer/Panel5/Button/dicesprite,
	5:$GridContainer/Panel6/Button/dicesprite,
	6:$GridContainer/Panel7/Button/dicesprite,
	7:$GridContainer/Panel8/Button/dicesprite,
	8:$GridContainer/Panel9/Button/dicesprite }

#game variables
var player_turn = null
var round_over = false

var player_die: int
var player_dice: Array = PlayerData.player_inventory.duplicate(true)
var opponent_die: int

var player_hp = PlayerData.player_hp
@export var opponent_hp: int = 150

#references
@onready var turn = $UIItems/TurnLabel
@onready var playerPan = $PlayerPan/Button
@onready var opponentPan = $OpponentPan/Button
@onready var playerDieSprite = $PlayerPan/Button/dicesprite
@onready var opponentDieSprite = $OpponentPan/Button/dicesprite

#on ready disable the pans from being interactable, flip a coin, update the turn
#connect to the player's boards grid updates function, and print HPs to labels
func _ready():
	_disable_bad_buttons()
	_inv_board_update()
	
	#State signals
	$GameStateMachine/playerturn.connect("update_die",_update_die)
	$GameStateMachine/opponentturn.connect("update_die",_update_die)
	$GameStateMachine/playerturn.connect("turn_track",_turn_track)
	$GameStateMachine/opponentturn.connect("turn_track",_turn_track)
	$GameStateMachine/playerturn.connect("toggle_action",_toggle_player_action)
	$GameStateMachine/opponentturn.connect("toggle_action",_toggle_player_action)
	$GameStateMachine/opponentturn.connect("opponent_action",_opponent_action)
	$GameStateMachine/scoring.connect("score_check",_score_check)
	
	#Board signals
	$PlayerBoard/Board.connect("gridUpdate",_onGridUpdate)
	$OpponentBoard/Board.connect("gridUpdate",_onGridUpdate)
	
	
	#UI text fields
	$UIItems/php.text = ("Player HP:" + str(player_hp))
	$UIItems/ohp.text = ("Opponent HP:" + str(opponent_hp))

#updates local player turn track var and UI
func _turn_track(player):
	if player == "player":
		player_turn = true
		turn.text = "Player Turn"
	else:
		player_turn = false
		turn.text = "Opponent Turn"

#this looks like the side boards update (currently it doesn't look like it removes the first item properly
#would love to get this called via the playerstate - maybe through it's exit?
func _inv_board_update():
	for key in playerInvSprites:
		if player_dice.size()-1 > key or player_dice.size()-1 == key:
			playerInvSprites[key].set_frame(5)
			playerInvSprites[key].visible = true
		else:
			playerInvSprites[key].visible = false

#updates players current die var and the pan with dice_roll result from PlayerStates
#makes the die pan visible/invisible on update based on player turn
func _update_die(player,die):
	if player == "player":
		player_die = die
		playerDieSprite.set_frame(die-1)
		playerDieSprite.visible = true
		opponentDieSprite.visible = false
	else:
		opponent_die = die
		opponentDieSprite.set_frame(die-1)
		opponentDieSprite.visible = true
		playerDieSprite.visible = false

#places the current die roll into the next available slot (dummyAI)
func _opponent_action():
	for key in oppBoardButtons:
		if (oppBoardState[key] == 0):
			_onGridUpdate(key)
			break

func _onGridUpdate(key):
	if player_turn == true:
		playerBoardState[key]=player_die
		playerBoardDice[key]=player_dice[0]
		_check_overlap(key, player_die)
		_board_update("player")
		player_dice.remove_at(0)
		$GameStateMachine/playerturn.board_updated(false)
		
	elif player_turn == false:
		oppBoardState[key]=opponent_die
		_check_overlap(key, opponent_die)
		_board_update("opp")
		$GameStateMachine/opponentturn.board_updated(false)

#updates the board visuals
func _board_update(who):
	if who == "player":
		for key in playerBoardButtons:
			if playerBoardState[key] != 0:
				playerBoardSprites[key].set_frame(playerBoardState[key]-1)
				playerBoardSprites[key].visible = true
			elif playerBoardState[key] == 0:
				playerBoardSprites[key].visible = false
	elif who == "opp":
		for key in oppBoardButtons:
			if oppBoardState[key] != 0:
				oppBoardSprites[key].set_frame(oppBoardState[key]-1)
				oppBoardSprites[key].visible = true
			elif oppBoardState[key] == 0:
				oppBoardSprites[key].visible = false
	_inv_board_update()

#loop through the playerBoardState and disable buttons, for all filled values increment counter
#on counter reaching 9 board if full, trigger round over
func _toggle_player_action():
	if player_turn == true:
		print("player input enabled.")
		var playerBoardFull = 0
		for key in playerBoardButtons:
			if (playerBoardState[key] != 0):
				playerBoardButtons[key].disabled = true
				playerBoardFull += 1
			else:
				playerBoardButtons[key].disabled = false
		$GameStateMachine/playerturn.board_updated(null)
		if (playerBoardFull == 9):
			$GameStateMachine/playerturn.board_updated(true)
	elif player_turn == false:
		print("player input disabled.")
		var oppBoardFull = 0
		for key in oppBoardButtons:
			if (oppBoardState[key] == 0):
				oppBoardButtons[key].disabled = false
			else:
				oppBoardButtons[key].disabled = true
				oppBoardFull += 1
		$GameStateMachine/opponentturn.board_updated(null)
		if (oppBoardFull == 9):
			$GameStateMachine/opponentturn.board_updated(true)

#toggles round over bool, clears the die for both players, runs score check
func _on_round_over():
	round_over = true
	player_die = 0
	opponent_die = 0
	_score_check()

#check for overlapping values in columns between players' boards
func _check_overlap(played_key,played_value):
	var column_letter = played_key.substr(0,1)
	if player_turn == true:
		for row in ["1","2","3"]:
			var key = str(column_letter,row)
			if oppBoardState[key] == played_value:
				oppBoardState[key] = 0
				oppBoardButtons[key].disabled = true
		_board_update("opp")
	else:
		for row in ["1","2","3"]:
			var key = str(column_letter,row)
			if (playerBoardState[key] == played_value):
				playerBoardState[key] = 0
				playerBoardButtons[key].disabled = false
#add dice back to the players game inventory
				player_dice.append(playerBoardDice[key])
		_board_update("player")

#run the board score, then call hp update - write values to screen
func _score_check():
	var player = playerBoardState.values()
	var playerA = [player[0],player[3],player[6]]
	var playerScoreA = _multiplier_check(playerA)
	$UIItems/ColA.text = str(playerScoreA)
	var playerB = [player[1],player[4],player[7]]
	var playerScoreB = _multiplier_check(playerB)
	$UIItems/ColB.text = str(playerScoreB)
	var playerC = [player[2],player[5],player[8]]
	var playerScoreC = _multiplier_check(playerC)
	$UIItems/ColC.text = str(playerScoreC)
	var playerTotal = playerScoreA+playerScoreB+playerScoreC
	$UIItems/PlayerScore.text = "Player Score:" + str(playerTotal)
	
	var opp = oppBoardState.values()
	var oppA = [opp[0],opp[3],opp[6]]
	var oppScoreA = _multiplier_check(oppA)
	$UIItems/ColA2.text = str(oppScoreA)
	var oppB = [opp[1],opp[4],opp[7]]
	var oppScoreB = _multiplier_check(oppB)
	$UIItems/ColB2.text = str(oppScoreB)
	var oppC = [opp[2],opp[5],opp[8]]
	var oppScoreC = _multiplier_check(oppC)
	$UIItems/ColC2.text = str(oppScoreC)
	var oppTotal = oppScoreA+oppScoreB+oppScoreC
	$UIItems/OpponentScore.text = "Opponent Score:" + str(oppTotal)
	
	_hp_update(playerTotal,oppTotal)

#check for multiples in a column and return multiplied value
func _multiplier_check(array):
	var multiplier = 1
	var score = 0
	for check in [0,1]:
		var count = array.count(array[check])
		if count == 3:
			multiplier = 9
			break
		elif count == 2:
			multiplier = 2
			break
	for element in array:
		score += element
	score = score*multiplier
	return score

#get the diff of scores, and update hp based on outputs, write to screen 
#trigger game over if ded
func _hp_update(player,opp):
	var diff = player - opp
	if diff >= 0:
		opponent_hp = opponent_hp - diff
		if opponent_hp <= 0:
			_game_over("Win")
			$UIItems/php.text = ("Player HP:" + str(player_hp))
			$UIItems/ohp.text = ("Opponent HP:" + str(opponent_hp))
			
			PlayerData.player_progress = PlayerData.player_progress +1
			PlayerData.wins = PlayerData.wins + 1
			
			if PlayerData.wins == 5:
				_you_are_the_best()
				return
			
			await get_tree().create_timer(2).timeout
			
			Global.goto_scene("res://Scenes/map_scene.tscn")
			return
	elif diff <= 0:
		player_hp = player_hp + diff
		PlayerData.player_hp = player_hp
		if player_hp <= 0:
			_game_over("Lose")
			$UIItems/php.text = ("Player HP:" + str(player_hp))
			$UIItems/ohp.text = ("Opponent HP:" + str(opponent_hp))
			
			PlayerData.player_hp = 150
			PlayerData.player_progress = 0
			
			await get_tree().create_timer(2).timeout
			
			Global.goto_scene("res://Scenes/start_menu.tscn")
			
			return
	$UIItems/php.text = ("Player HP:" + str(player_hp))
	$UIItems/ohp.text = ("Opponent HP:" + str(opponent_hp))
	_next_round_enable()

#enable next round button and hook up signal to board reset
func _next_round_enable():
	$UIItems/NextRoundButton.visible = true
	$UIItems/NextRoundButton.connect("pressed",_reset_boards)

#enable retry button and hook up signal to board and hp reset
func _retry_enable():
	$UIItems/RetryButton.visible = true
	$UIItems/RetryButton.connect("pressed",_reset)

#display result of the match, enable retry button
func _game_over(result):
	turn.text = result
	_retry_enable()

#restores both player and opp HP to 150 - disables retry button
func _reset():
	player_hp = 150
	opponent_hp = 150
	_reset_boards()
	$UIItems/RetryButton.visible = false
	$UIItems/RetryButton.disconnect("pressed",_reset)

#reset both board dictionaries, and score columns to neutral, reset player turn to null, 
#and flip a coin/update the turn
func _reset_boards():
	playerBoardState = {"A1":0,
		"B1":0,
		"C1":0,
		"A2":0,
		"B2":0,
		"C2":0,
		"A3":0,
		"B3":0,
		"C3":0}
	playerBoardDice = {"A1":"empty",
		"B1":"empty",
		"C1":"empty",
		"A2":"empty",
		"B2":"empty",
		"C2":"empty",
		"A3":"empty",
		"B3":"empty",
		"C3":"empty"}
	oppBoardState = {"A1":0,
		"B1":0,
		"C1":0,
		"A2":0,
		"B2":0,
		"C2":0,
		"A3":0,
		"B3":0,
		"C3":0}
	player_dice = PlayerData.player_inventory.duplicate(true)
	print(PlayerData.player_inventory)
	print(player_dice)
	playerDieSprite.visible = false
	opponentDieSprite.visible = false
	player_turn = null
	_board_update("player")
	_board_update("opp")
	for key in playerBoardButtons:
		playerBoardButtons[key].disabled = false
	for key in oppBoardButtons:
		oppBoardButtons[key].disabled = false
	$UIItems/ColA.text = "---"
	$UIItems/ColB.text = "---"
	$UIItems/ColC.text = "---"
	$UIItems/ColA2.text = "---"
	$UIItems/ColB2.text = "---"
	$UIItems/ColC2.text = "---"
	$UIItems/NextRoundButton.visible = false
	$UIItems/NextRoundButton.disconnect("pressed",_reset_boards)
	round_over = false
	$GameStateMachine/scoring.next_round()
#TODO: this turn_update fails on a game ended by the opponent, array isn't refilling
#Invalid get index '0' on base 'Array'

#disable the pan buttons
func _disable_bad_buttons():
	playerPan.disabled = true
	opponentPan.disabled = true

func _you_are_the_best():
	$UIItems/BestButton.visible = true
	
func _on_cheat_pressed():
	_hp_update(150,0)

func _on_best_button_pressed():
	Global.goto_scene("res://Scenes/start_menu.tscn")
