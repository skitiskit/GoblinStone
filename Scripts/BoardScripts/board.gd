extends GridContainer

signal gridUpdate

var dice_panel = preload("res://Scenes/BoardPieces/DicePanel.tscn")

var grid_instance_dict = {}
var grid_key_array = ["A1","B1","C1","A2","B2","C2","A3","B3","C3"]

func _ready():
	var instance_name
	var cycle = 0
	for n in grid_key_array:
		instance_name = str(grid_key_array[cycle])
		grid_instance_dict[grid_key_array] = dice_panel.instantiate()
		add_child(grid_instance_dict[grid_key_array])
		grid_instance_dict[grid_key_array].set_name(instance_name)
		grid_instance_dict[grid_key_array].connect("selected", _on_selected)
		cycle += 1

func _on_selected(gridKey):
	emit_signal("gridUpdate", gridKey)
