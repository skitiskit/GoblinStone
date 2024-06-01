extends Control

#board dictionaries
var playerBoardState = {"A1":0,"B1":0,"C1":0,"A2":0,"B2":0,"C2":0,"A3":0,"B3":0,"C3":0}
var oppBoardState = {"A1":0,"B1":0,"C1":0,"A2":0,"B2":0,"C2":0,"A3":0,"B3":0,"C3":0}
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
#game variables
var player_turn = null
var round_over = false
var coin_flip: int

var player_die
var opponent_die

@export var  player_hp: int = 150
@export var opponent_hp: int = 150



#references
@onready var turn = $TurnLabel
@onready var playerPan = $PlayerPan/Button
@onready var opponentPan = $OpponentPan/Button

#on ready disable the pans from being interactable, flip a coin, update the turn
#connect to the player's boards grid updates function, and print HPs to labels
func _ready():
	_disable_bad_buttons()
	_coin_flip()
	_turn_update()
	
	$PlayerBoard/Board.connect("gridUpdate",_onGridUpdate)
	$OpponentBoard/Board.connect("gridUpdate",_onGridUpdate)
	
	$php.text = ("Player HP:" + str(player_hp))
	$ohp.text = ("Opponent HP:" + str(opponent_hp))

#flips a coin 0 heads, 1 tails
func _coin_flip():
	coin_flip = randi_range(0,1)
	print(coin_flip)

#checks if player_turn is defined, if not, checks for coin_flip value and sets turn.
func _turn_update():
	if player_turn == null:
		if coin_flip != 0:
			player_turn = false
			turn.text = "Opponent Turn"
			_toggle_player_action()
		else:
			player_turn = true
			_toggle_opp_action()
		_dice_roll()
	else:
		if player_turn == true:
			turn.text = "Opponent Turn"
			_toggle_player_action()
			_toggle_opp_action()
			player_turn = false
			playerPan.text = "---"
			_dice_roll()
		else:
			turn.text = "Player Turn"
			_toggle_opp_action()
			_toggle_player_action()
			player_turn = true
			opponentPan.text = "---"
			_dice_roll()

#rolls 1d6 - prints value current players pan - if opp. wait 1.5s then take their turn
func _dice_roll():
	if player_turn == true:
		player_die = randi_range(1,6)
		playerPan.text = str(player_die)
	else:
		opponent_die = randi_range(1,6)
		opponentPan.text = str(opponent_die)
		
		await get_tree().create_timer(1.5).timeout
		
		_opponent_action()

#places the current die roll into the next available slot (dummyAI)
func _opponent_action():
	for key in oppBoardButtons:
		if (oppBoardState[key] == 0):
			_onGridUpdate(key)
			break

func _onGridUpdate(key):
	if player_turn == true:
		playerBoardState[key]=player_die
		_check_overlap(key, player_die)
		_player_board_update()
	else:
		oppBoardState[key]=opponent_die
		_check_overlap(key, opponent_die)
		_opp_board_update()
	
	if round_over == false:
		_turn_update()
#update player board with values in playerBoardState dictionary
func _player_board_update():
	for key in playerBoardButtons:
		playerBoardButtons[key].text = str(playerBoardState[key])
#update opponent board with values in opponentBoardState dictionary
func _opp_board_update():
	for key in oppBoardButtons:
		oppBoardButtons[key].text = str(oppBoardState[key])
#loop through the playerBoardState and disable buttons, for all filled values increment counter
#on counter reaching 9 board if full, trigger round over
func _toggle_player_action():
	var playerBoardFull = 0
	for key in playerBoardButtons:
		if (playerBoardState[key] == 0):
			playerBoardButtons[key].disabled = !playerBoardButtons[key].disabled
		else:
			playerBoardButtons[key].disabled = true
			playerBoardFull += 1
	if (playerBoardFull == 9):
		_on_round_over()
#loop through the playerBoardState and disable buttons, for all filled values increment counter
#on counter reaching 9 board if full, trigger round over
func _toggle_opp_action():
	var oppBoardFull = 0
	for key in oppBoardButtons:
		if (oppBoardState[key] == 0):
			oppBoardButtons[key].disabled = !oppBoardButtons[key].disabled
		else:
			oppBoardButtons[key].disabled = true
			oppBoardFull += 1
	if (oppBoardFull == 9):
		_on_round_over()
	
func _on_round_over():
	round_over = true
	player_die = "---"
	opponent_die = "---"
	_score_check()

func _check_overlap(played_key,played_value):
	var column_letter = played_key.substr(0,1)
	if player_turn == true:
		for row in ["1","2","3"]:
			var key = str(column_letter,row)
			if oppBoardState[key] == played_value:
				oppBoardState[key] = 0
				_opp_board_update()
	else:
		for row in ["1","2","3"]:
			var key = str(column_letter,row)
			if (playerBoardState[key] == played_value):
				playerBoardState[key] = 0
				_player_board_update()
				
func _score_check():
	var player = playerBoardState.values()
	var playerA = [player[0],player[3],player[6]]
	var playerScoreA = _multiplier_check(playerA)
	$ColA.text = str(playerScoreA)
	var playerB = [player[1],player[4],player[7]]
	var playerScoreB = _multiplier_check(playerB)
	$ColB.text = str(playerScoreB)
	var playerC = [player[2],player[5],player[8]]
	var playerScoreC = _multiplier_check(playerC)
	$ColC.text = str(playerScoreC)
	var playerTotal = playerScoreA+playerScoreB+playerScoreC
	$PlayerScore.text = str(playerTotal)
	
	var opp = oppBoardState.values()
	var oppA = [opp[0],opp[3],opp[6]]
	var oppScoreA = _multiplier_check(oppA)
	$ColA2.text = str(oppScoreA)
	var oppB = [opp[1],opp[4],opp[7]]
	var oppScoreB = _multiplier_check(oppB)
	$ColB2.text = str(oppScoreB)
	var oppC = [opp[2],opp[5],opp[8]]
	var oppScoreC = _multiplier_check(oppC)
	$ColC2.text = str(oppScoreC)
	var oppTotal = oppScoreA+oppScoreB+oppScoreC
	$OpponentScore.text = str(oppTotal)
	
	_hp_update(playerTotal,oppTotal)
	
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

func _hp_update(player,opp):
	var diff = player - opp
	if diff >= 0:
		opponent_hp = opponent_hp - diff
		if opponent_hp <= 0:
			_game_over("win")
			$php.text = ("Player HP:" + str(player_hp))
			$ohp.text = ("Opponent HP:" + str(opponent_hp))
			return
	elif diff <= 0:
		player_hp = player_hp + diff
		if player_hp <= 0:
			_game_over("lose")
			$php.text = ("Player HP:" + str(player_hp))
			$ohp.text = ("Opponent HP:" + str(opponent_hp))
			return
	$php.text = ("Player HP:" + str(player_hp))
	$ohp.text = ("Opponent HP:" + str(opponent_hp))
	_next_round_enable()

func _next_round_enable():
	$NextRoundButton.visible = true
	$NextRoundButton.connect("pressed",_reset_boards)
	
func _retry_enable():
	$RetryButton.visible = true
	$RetryButton.connect("pressed",_reset_boards)
	$RetryButton.connect("pressed",_reset_hp)

func _game_over(result):
	turn.text = result
	_retry_enable()
#restores both player and opp HP to 150 - disables retry button
func _reset_hp():
	player_hp = 150
	opponent_hp = 150
	$RetryButton.visible = false
	$RetryButton.disconnect("pressed",_reset_boards)

func _reset_boards():
	playerBoardState = {"A1":0,"B1":0,"C1":0,"A2":0,"B2":0,"C2":0,"A3":0,"B3":0,"C3":0}
	oppBoardState = {"A1":0,"B1":0,"C1":0,"A2":0,"B2":0,"C2":0,"A3":0,"B3":0,"C3":0}
	_player_board_update()
	_opp_board_update()
	$ColA.text = "---"
	$ColB.text = "---"
	$ColC.text = "---"
	$ColA2.text = "---"
	$ColB2.text = "---"
	$ColC2.text = "---"
	$NextRoundButton.visible = false
	$NextRoundButton.disconnect("pressed",_reset_boards)
	round_over = false
	_coin_flip()
	_turn_update()

func _disable_bad_buttons():
	playerPan.disabled = true
	opponentPan.disabled = true
