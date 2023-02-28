class_name GameEnums extends Object

enum AppSlateType {
	HOME,
	TEXT,
	BANKING,
	FLIGHTS, 
}

# I haven't decided what these will be yet so for now it's just none
enum GameStoryBeat {
	DEBUG,
	EOF,
	NONE
}

static func string_to_gamestorybeat(enum_string : String) -> int:
	var string_to_gamestorybeat_dict = {
		"DEBUG" : GameStoryBeat.DEBUG,
		"EOF"	: GameStoryBeat.EOF,
		"NONE"	: GameStoryBeat.NONE
	}
	
	if string_to_gamestorybeat_dict.has(enum_string):
		return string_to_gamestorybeat_dict[enum_string]
		
	push_warning("GameEnums.string_to_gamestorybeat: %s is not a valid enum name".format([enum_string]))
	return GameStoryBeat.NONE
