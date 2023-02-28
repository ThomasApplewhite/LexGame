# PromptLivesTrackerHBoxContainer
extends HBoxContainer

Handles the tracking of a prompt's 'lives', which are markers that show how far along the player is in a given prompt. How many lives should be shown is up to the client/caller/parent/whatever of the PromptLivesTrackerHBoxContainer (aka the PromptLives), but iterating over the life markers and organizing them is the PromptLives' responsibility.

PromptLives is an HBoxContainer, so it will horizontally organize its children automatically. 

btw, _fields_ and _child nodes_ are _italics_, while **functions** and **signals** are **bold**.

### Fields
field: purpose

lives_scene: Preloads the scene of the PromptLifeMarker, so that it can be instanced later

lives: an array intended to hold instances PromptLifeMarker objects

lives_index: the current index in the lives array from where we should iterate lives from. This number also represents the amount of lives that should be visible, since array indicies start at 0 (if we're focusing on index 3, then 0, 1, and 2 will be visible. That's 3!)

max_lives: The amount of lives to track and PromptLifeMarkers to spawn

## func function(arg : arg_type)
Summary of the function's args and what it does


## func init_prompt_lives(new_max_lives : int):
Initializes _max_lives_ and generates _max_lives_ many PromptLifeMarkers. These PromptLifeMarkers are instanced, added to the _lives_ array, and immediately added as a child of the PromptLives node. 
	
## func set_marked_lives(new_lives : int):
	Calls **process_lives_change(_new_lives_)**
	
## func increment_marked_lives(new_life_increment : int):
	Calls **process_lives_change(_lives_index_+_new_life_increment_)**
	
## func process_lives_change(in_lives_index : int):
Clamps the incoming _in_lives_index_ into 0 to _max_lives_ (inclusive) and saves it to the local new_lives_index_ variable. If _new_lives_index and _lives_index_ are the same, the method returns.

If they _aren't_ the same, a _lives_increasing_ local variable checks if the PromptLives needs to increase or decrease the number of lives. It then iterates in that direction by toggling the current index's PromptLifeMarker to _lives_increasing_ and then incrementing by 1 (positive if _lives_increasing_ is true and negative if _lives_increasing_ is false) until _lives_index_ and new_lives_index_ are the same.

If the final _lives_index_ is valid for the _lives_ array, the PromptLifeMarker in that index is then set to false. This is to make sure only the indicies before _lives_index_ show their life markers.