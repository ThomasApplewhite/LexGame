extends Node

export var gsb_list_resource : Resource

onready var phone_control = $PhoneControl
var messanger_appslate 

var required_gsb_index : int = 0

func _ready():
	# Make sure we have the right kind of resource:
	if !gsb_list_resource.is_type("GameStoryBeatList"):
		push_error("Wrong resource type lol!")
		return
	
	messanger_appslate = get_messanger_appslate()
	
# Appslate, but custom types can't be hints
func get_messanger_appslate() -> Node:
	return phone_control.appslate_dict[GameEnums.AppSlateType.TEXT]
	
func get_required_gsb() -> int:
	return gsb_list_resource.get_game_story_beat_at_index(required_gsb_index)

	
func advance_required_story_beat():
	required_gsb_index += 1
	if(get_required_gsb() == GameEnums.GameStoryBeat.EOF):
		end_game()

# Move the game to the end-game scene. Just not right now, its not ready yet.
func end_game():
	pass

# Responds to incoming GSBs, primarily by advancing the story if the GSB is
# currently required. If something else should happen from the GSB, it should
# be determined and started here
func evaluate_game_story_beat(story_beat):
	if(story_beat == get_required_gsb()):
		advance_required_story_beat()

# Recieves game story beats from appslates
func _on_game_story_beat_triggered(story_beat):
	evaluate_game_story_beat(story_beat)

