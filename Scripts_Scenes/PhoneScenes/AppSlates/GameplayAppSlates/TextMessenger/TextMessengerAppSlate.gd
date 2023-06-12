extends AppSlate

export(Array, NodePath) var convo_entry_node_paths
export(PackedScene) var convo_entry_button_scene

onready var convo_entry_button_vbox = $DebugBorderColorRect/VBoxContainer

signal GameStoryBeatAdvanced(old_story_beat, old_frequency, new_story_beat, new_frequency)
var gsb_advanced_signal_name = "GameStoryBeatAdvanced" # setget , _get_gsb_advanced_signal_name

signal RequestGameStoryBeatFrequency(story_beat, requesting_entry)
var gsb_frequency_signal_name = "RequestGameStoryBeatFrequency" setget, _get_gsb_frequency_signal_name

var gsb_advanced_reciever_name = "_on_game_story_beat_advanced" setget , _get_gsb_advanced_reciever_name
var convo_entry_button_reciever_name = "_on_convo_entry_button_pressed"

var active_convo_entry

func _ready():
	generate_convo_entry_buttons()
	
func generate_convo_entry_buttons():
	var working_convo_entry
	var working_convo_entry_button
	var pressed_signal_name
	for convo_entry_path in convo_entry_node_paths:
		working_convo_entry = get_node(convo_entry_path)
		
		# Create and parent button
		working_convo_entry_button = convo_entry_button_scene.instance()
		convo_entry_button_vbox.add_child(working_convo_entry_button)
		
		# Set up button data
		pressed_signal_name = working_convo_entry_button.get_pressed_signal_name()
		working_convo_entry_button.set_initials_text(working_convo_entry.message_button_initial)
		# TODO: working_convo_entry_button.set_message_text(??) Not sure how to do this yet.
		working_convo_entry_button.connect(pressed_signal_name, self, convo_entry_button_reciever_name)
		working_convo_entry_button.set_convo_entry_node(working_convo_entry)
		
func activate_new_conversation(new_convo_entry : Node):
	if(active_convo_entry):
		deactivate_current_conversation()
	
	new_convo_entry.create_conversation_slate()
	active_convo_entry = new_convo_entry
	
func deactivate_current_conversation():
	active_convo_entry.remove_conversation_slate()
	
	active_convo_entry = null

func _get_gsb_advanced_reciever_name() -> String:
	return gsb_advanced_reciever_name
	
func _get_gsb_frequency_signal_name() -> String:
	return gsb_frequency_signal_name
	
func _on_convo_entry_button_pressed(button_pressed, associated_convo_entry):
	activate_new_conversation(associated_convo_entry)

func _on_game_story_beat_advanced(old_story_beat, old_frequency : int, new_story_beat, new_frequency : int):
	emit_signal(gsb_advanced_signal_name, old_story_beat, old_frequency, new_story_beat, new_frequency)

# When a convo_entry requests a notification signal, pass it along to the phone
func _on_notification_request_from_convo_entry(notification_text : String):
	emit_signal(notification_signal_name, GameEnums.AppSlateType.TEXT, notification_text)

func _on_gsb_frequency_info_request(requesting_node :  Node, story_beat):
	# Emit the info request signal. GameDaemon will send the needed info
	emit_signal(gsb_frequency_signal_name, story_beat, requesting_node)

func _on_game_story_beat_triggered(story_beat : int):
	emit_signal(story_beat_signal_name, story_beat)
	
func _on_back_button_pressed():
	if(active_convo_entry):
		deactivate_current_conversation()
	else:
		emit_signal(_get_slate_change_signal_name(), GameEnums.AppSlateType.HOME)
		
func _on_home_button_pressed():
	emit_signal(_get_slate_change_signal_name(), GameEnums.AppSlateType.HOME)
