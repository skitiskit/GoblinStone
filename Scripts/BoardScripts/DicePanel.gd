extends Panel

signal selected

func _on_button_pressed():
	emit_signal("selected", self.name)

func _dice_roll():
	Dice.d6_sprite.play("roll")
