extends Node

var current_scene = null

@export var player_hp: int = 150

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	print(current_scene)

func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)
	
func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	
	current_scene = s.instantiate()
	
	get_tree().root.add_child(current_scene)
	
	get_tree().current_scene = current_scene

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
