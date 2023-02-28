extends Control

# This script just handles the appearance of a LifeMarker. And nothing else.

func _ready():
	$TextureRect.visible = false
	
func toggle_life_marker_on(toggle_on : bool):
	$TextureRect.visible = toggle_on
