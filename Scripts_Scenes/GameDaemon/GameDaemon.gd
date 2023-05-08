extends Node

export var gsb_list_resource : Resource

onready var phone_control = $PhoneControl
var messanger_appslate 

var required_gsb_index : int = 0
var recieved_gsb_dict = {
	GameEnums.GameStoryBeat.NONE : -1, 
	GameEnums.GameStoryBeat.EOF : -1 
}

signal GameStoryBeatAdvanced(old_story_beat, old_frequency, new_story_beat, new_frequency)
var gsb_advanced_signal_name = "GameStoryBeatAdvanced" # setget , _get_gsb_advanced_signal_name

var gsb_frequency_reciever_name = "_on_gsb_frequency_requested"

func _ready():
	# Make sure we have the right kind of resource:
	if !gsb_list_resource.is_type("GameStoryBeatList"):
		push_error("Wrong resource type lol!")
		return
	
	# how do I connect the signal
	# sender_object.connect(signal_name, target_object, handller_method)
	
	# The signal below is connected wrong, fix that!
	# What was it even for?
	messanger_appslate = get_messanger_appslate()
	connect(gsb_advanced_signal_name, messanger_appslate,messanger_appslate.gsb_advanced_reciever_name)
	messanger_appslate.connect(messanger_appslate._get_gsb_frequency_signal_name(), self, gsb_frequency_reciever_name)
	
# Appslate, but custom types can't be hints
func get_messanger_appslate() -> Node:
	return phone_control.appslate_dict[GameEnums.AppSlateType.TEXT]
	
func get_required_gsb() -> int:
	return gsb_list_resource.get_game_story_beat_at_index(required_gsb_index)
	
func get_gsb_at_index(gsb_index : int) -> int:
	return gsb_list_resource.get_game_story_beat_at_index(gsb_index)

func get_recieved_game_story_beat_frequency(story_beat) -> int:
	var has_gsb = recieved_gsb_dict.has(story_beat)
	return recieved_gsb_dict[story_beat] if has_gsb else 0
	
func advance_required_story_beat():
	var old_gsb = get_gsb_at_index(required_gsb_index)
	var new_gsb = get_gsb_at_index(required_gsb_index + 1)
	
	required_gsb_index += 1
	
	if(get_required_gsb() == GameEnums.GameStoryBeat.EOF):
		end_game()
	else:
		
		emit_signal(gsb_advanced_signal_name, old_gsb, recieved_gsb_dict[old_gsb], new_gsb, recieved_gsb_dict[new_gsb])

# Move the game to the end-game scene. Just not right now, its not ready yet.
func end_game():
	pass

# Responds to incoming GSBs, primarily by advancing the story if the GSB is
# currently required. If something else should happen from the GSB, it should
# be determined and started here
func evaluate_game_story_beat(story_beat):
	if (story_beat == GameEnums.GameStoryBeat.NONE || story_beat == GameEnums.GameStoryBeat.EOF):
		return
	
	recieved_gsb_dict[story_beat] += 1
	
	if(story_beat == get_required_gsb()):
		advance_required_story_beat()

# Recieves game story beats from appslates
func _on_PhoneControl_StoryBeatTriggered(story_beat):
	evaluate_game_story_beat(story_beat)
	
func _on_gsb_frequency_requested(story_beat, requesting_node : Node):
	var gsb_frequency = get_recieved_game_story_beat_frequency(story_beat)
	requesting_node.evaluate_game_story_beat_requirements(story_beat, gsb_frequency)




