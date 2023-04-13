extends Node

export var gsb_list_resource : Resource

onready var phone_control = $PhoneControl
var messanger_appslate 

var required_gsb_index : int = 0
var recieved_gsb_dict = {}

signal GameStorBeatAdvanced(story_beat, frequency)
var gsb_advanced_signal_name = "GameStorBeatAdvanced" # setget , _get_gsb_advanced_signal_name

func _ready():
	# Make sure we have the right kind of resource:
	if !gsb_list_resource.is_type("GameStoryBeatList"):
		push_error("Wrong resource type lol!")
		return
	
	messanger_appslate = get_messanger_appslate()
	var gsb_reciever_method = messanger_appslate.gsb_advanced_reciever_name
	messanger_appslate.connect(gsb_advanced_signal_name)
	
# Appslate, but custom types can't be hints
func get_messanger_appslate() -> Node:
	return phone_control.appslate_dict[GameEnums.AppSlateType.TEXT]
	
func get_required_gsb() -> int:
	return gsb_list_resource.get_game_story_beat_at_index(required_gsb_index)

func get_recieved_game_story_beat_frequency(story_beat) -> int:
	var has_gsb = recieved_gsb_dict.has(story_beat)
	return recieved_gsb_dict[story_beat] if has_gsb else 0
	
func advance_required_story_beat():
	required_gsb_index += 1
	if(get_required_gsb() == GameEnums.GameStoryBeat.EOF):
		end_game()
	else:
		var new_gsb = get_required_gsb()
		emit_signal(gsb_advanced_signal_name, new_gsb, recieved_gsb_dict[new_gsb])

# Move the game to the end-game scene. Just not right now, its not ready yet.
func end_game():
	pass

# Responds to incoming GSBs, primarily by advancing the story if the GSB is
# currently required. If something else should happen from the GSB, it should
# be determined and started here
func evaluate_game_story_beat(story_beat):
	recieved_gsb_dict[story_beat] += 1
	
	if(story_beat == get_required_gsb()):
		advance_required_story_beat()

# Recieves game story beats from appslates
func _on_game_story_beat_triggered(story_beat):
	evaluate_game_story_beat(story_beat)

