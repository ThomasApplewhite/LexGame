class_name GameStoryBeatList extends Resource

export(Array, GameEnums.GameStoryBeat) var GSBOrder

func _init():
	pass
	
func is_type(type): 
	return type == get_type()
	
func get_type(): 
	return "GameStoryBeatList"
	
# Index getter. Returns int because enums can't be type hints.
func get_game_story_beat_at_index(index : int) -> int:
	# If we get a negative index for some reason, EOF
	if(index < 0):
		var err = "GameStoryBeatList.get_game_story_beat_at_index: Index {0} is invalid!"
		push_error(err.format({0: index}))
		return GameEnums.GameStoryBeat.NONE
	
	# If we get too large of an index, then we're out of GSBs. Return EOF.
	if(index >= GSBOrder.size()):
		return GameEnums.GameStoryBeat.EOF
	
	# If in range, return element at index
	return GSBOrder[index]
