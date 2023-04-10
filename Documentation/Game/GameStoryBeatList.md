# GameStoryBeatList 
extends Resource

GameStoryBeatList is an asset that contains an inspector-defined array of GameStoryBeats. These can be used for anything, but they're primarily designed to be used by GameDaemon. GameDaemon uses a GameStoryBeatList to decide which things need to happen (and which in order) for the game to be progressed and ultimately finished.

GameStoryBeatList is a class_name'd type. It is not designed to be instanced in a script.

### Fields
export GSBOrder: An array of GameStoryBeats. See the description for what this is for, as holding such an array as a resource is the primary purpose of the class.

## func _init():
Constructor. Does nothing, but I think this needs to be defined for the Resource to work as an asset.

## func is_type(type): 
Overrides the default **is_type(type)** to use this type's more specific type. 
return _type_ == **get_type()**

## func get_type(): 
Overrides the default **get_type()** method so that this type's type is more specific than 'Resource'
return "GameStoryBeatList"
	
## func get_game_story_beat_at_index(index : int) -> int:
Accessor. Returns _GSBOrder[index]_, assuming that _index_ is in bounds. If _index_ is above bounds, this method returns GameStoryBeat.EOF. If _index_ is below bounds, this method returns GameStoryBeat.NONE and pushes an error.