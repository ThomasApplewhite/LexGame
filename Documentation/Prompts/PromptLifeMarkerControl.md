# PromptLifeMarkerControl
extends Control

This script just handles the appearance of a LifeMarker. And nothing else.

btw, _fields_ and _child nodes_ are _italics_, while **functions** and **signals** are **bold**.

### Child Nodes
TextureRect: The image that represents the life

## func _ready():
Sets the _TextureRect.visible_ to false so the life can't be seen on spawn. Doesn't use the toggle method because that method may include other effects that we don't want to happen.
	
## func toggle_life_marker_on(toggle_on : bool):
Sets _TextureRect.visible_ to _toggle_on_. May handle other life on/off visuals in the future.
