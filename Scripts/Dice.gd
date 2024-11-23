#Stores all the various die types and allows for the animation of thier sprites
#TODO give new specified sprites to each dice type
	#currently only plain D6 exists
#TODO can I call animations from here maybe? to do my rolls?
#TODO you're going to load all the sprite sheets into memory on load aren't you 
#fine, do it, but you know there's probably a smarter way to do this
extends Node

var d6 = [1,2,3,4,5,6]
var d4 = [1,2,3,4]
var weighted_d6 = [1,2,3,4,4,5,5,6,6]
var weighted_d4 = [1,2,3,3,4,4]
var unlucky_d6 = [1,1,2,2,3,3,4,5,6]
var d6_sprite_sheet = load("res://Assets/D6-Sprites-Sheet.png")

func _ready() -> void:

	anim_sprites(d6_sprite_sheet,"d6_sprite")
	anim_sprites(d6_sprite_sheet,"d4_sprite")


func anim_sprites(resource,sprite_name):
	var sprite := AnimatedSprite2D.new()
	var sprite_frames := SpriteFrames.new()
	sprite_frames.add_animation("roll")
	sprite_frames.set_animation_loop("roll",false)
	var texture_size := Vector2(32,192)
	var sprite_size := Vector2(32,32)
	var sprite_sheet = resource
	var num_columns : int = int(texture_size.x/sprite_size.y)
	for x_coords in range(num_columns):
		for y_coords in range(int(texture_size.y/sprite_size.y)):
			var frame_tex := AtlasTexture.new()
			frame_tex.atlas = sprite_sheet
			frame_tex.region = Rect2(Vector2(x_coords,y_coords)*sprite_size,sprite_size)
			sprite_frames.add_frame("roll",frame_tex,y_coords*num_columns+x_coords)
	sprite.frames = sprite_frames
	add_child(sprite)
	sprite.name = sprite_name
	sprite.position = Vector2(32,32)
