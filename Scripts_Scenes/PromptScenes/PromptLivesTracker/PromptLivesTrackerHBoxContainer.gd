extends HBoxContainer


# The lives tracker just creates n many 'lives' markers and updates which
# ones are filled or not depending on input

var lives_scene = preload("res://Scripts_Scenes/PromptScenes/PromptLivesTracker/PromptLifeMarker/PromptLifeMarkerControl.tscn")

var lives = []
var lives_index = 0
var max_lives = 0

func init_prompt_lives(new_max_lives : int):
	var new_life
	max_lives = new_max_lives
	
	for new_life_index in max_lives:
		# instance the life marker and attach to node
		new_life = lives_scene.instance()
		lives.append(new_life)
		add_child(new_life)
	
func set_marked_lives(new_lives : int):
	process_lives_change(new_lives)
	
func increment_marked_lives(new_life_increment : int):
	process_lives_change(lives_index+new_life_increment)
	
func process_lives_change(in_lives_index : int):
	# clamp new_lives_index if it's bigger than max_lives (or would it max_lives - 1) or smaller than 0
	# yes this method is technically for floats but who cares
	var new_lives_index = clamp(in_lives_index, 0 ,max_lives)
	
	# if the new index is the current index, do nothing
	if(new_lives_index == lives_index):
		return
	
	# increment through each life index and toggle along the way
	var lives_increasing = new_lives_index > lives_index
	while lives_index != new_lives_index:
		lives[lives_index].toggle_life_marker_on(lives_increasing)
		lives_index += (1 if lives_increasing else -1)
	# manually set ending index to false because the current index should always be false
	
	if(lives_index < max_lives):
		lives[lives_index].toggle_life_marker_on(false)
