extends Node

enum DisplayCondition {
	FIRSTTIMER,
	STORYBEAT
}

enum GSBRequirement {
	BEAT,
	FREQ
}

const default_display_conditions = {
	DisplayCondition.FIRSTTIMER : false,
	DisplayCondition.STORYBEAT : true # this should be false
}

const default_gsb_requirements = {}

export(String) var message_button_initial

# needs to hold convo asset and convo slate type and convo slate itself
export var conversation_resource : Resource
var convo_slate_scene = preload("res://Scripts_Scenes/PhoneScenes/AppSlates/GameplayAppSlates/TextMessenger/ConversationAppSlate.tscn")
var convo_slate : Node

# Signal-Related Variables
signal RequestNotificationWithText(notification_text)
var notif_with_text_signal_name = "RequestNotificationWithText"
signal RequestGSBFrequencyInfo(requesting_convo_entry, story_beat)
var request_frequency_signal_name = "RequestGSBFrequencyInfo"
signal GameStoryBeatTriggered(story_beat)
var story_beat_signal_name = "GameStoryBeatTriggered" # setget , _get_story_beat_signal_name

var gsb_advanced_reciever_name = "_on_game_story_beat_advanced"

# Convo-Slate State Variables
var do_next_convo = default_display_conditions.duplicate()
var game_story_beat_requirements = default_gsb_requirements.duplicate()
var convo_slate_is_active : bool setget , _get_convo_slate_is_active
var last_displayed_chunk_text : String = ""
var last_displayed_chunk_index : int = -1

func create_conversation_slate():
	convo_slate = convo_slate_scene.instance()
	convo_slate.initialize_convo_slate(conversation_resource, self, last_displayed_chunk_index)
	add_child(convo_slate)
	convo_slate.start_convo_slate()
	
func remove_conversation_slate():
	last_displayed_chunk_index = convo_slate.end_convo_slate()
	convo_slate.queue_free()
	convo_slate = null

# the conditional here is expanded because it appear that Godot doesn't have
# short-circuit logical comparisons	
func _get_convo_slate_is_active() -> bool:
	if !convo_slate:
		return false
	
	return convo_slate.is_inside_tree()

# --- TIMER HANDLING ---

func cancel_and_restart_timer(timer : Node, wait_time : float):
	timer.stop()
	timer.wait_time = wait_time
	timer.start()
	
func send_notification_to_phone():
	# Only send notifications for this conversation if they aren't being looked at right now
	if(!convo_slate_is_active):
		emit_signal(notif_with_text_signal_name, last_displayed_chunk_text)

func handle_display_appslate(display_condition : int):
	do_next_convo[display_condition] = true
	var ready = do_next_convo[DisplayCondition.FIRSTTIMER] && do_next_convo[DisplayCondition.STORYBEAT]
	
	# if it's not time to display the next part of the conversation, don't.
	if(!ready):
		return
		
	# if it is time, do everything in the rest of the function!
	
	# Regardless of slate activity, send the relevant sent GameStoryBeat to the TextMessangerAppSlate
	var triggered_story_beat = convo_slate.get_current_convo_dict_send_story_beat()
	emit_signal(story_beat_signal_name, triggered_story_beat)
	
	# And reset the display conditions
	reset_conditional_dicts()
	
	# if the convo slate isn't active, just advance the current convo index and don't display anything
	if(!_get_convo_slate_is_active()):
		print("Advancing Undisplayed Dict Index: {0}".format({0: last_displayed_chunk_index}))
		last_displayed_chunk_index += 1
	else:
		# If we are ready, display the text (or prompt),
		last_displayed_chunk_text = convo_slate.handle_next_convo_dict()
	
	# And send a notif to the phone
	send_notification_to_phone()

func create_game_story_beat_requirements(required_gsb, required_frequency : int):
	# No GSB required? Just update the display conditions and move on!
	if(required_gsb == GameEnums.GameStoryBeat.NONE):
		handle_display_appslate(DisplayCondition.STORYBEAT)
		return
	
	# if not, save the information for later signals, just in case
	game_story_beat_requirements = {
		GSBRequirement.BEAT : required_gsb,
		GSBRequirement.FREQ : required_frequency
	}
	
	#Ask TextMessageAppSlate for frequency information
	emit_signal(request_frequency_signal_name, self, required_gsb)
	
func evaluate_game_story_beat_requirements(story_beat, story_beat_frequency : int):
	#  No story beats required? Ignore.
	if(game_story_beat_requirements.empty()):
		return
		
	# If there are requirements, check if the incoming signals match them
	var beat_match = game_story_beat_requirements[GSBRequirement.BEAT] == story_beat
	var freq_match = game_story_beat_requirements[GSBRequirement.FREQ] <= story_beat_frequency
	
	if(beat_match & freq_match):
		handle_display_appslate(DisplayCondition.STORYBEAT)
		
func reset_conditional_dicts():
	# We want fresh versions of the default dicts, so they must all be duplicated
	do_next_convo = default_display_conditions.duplicate()
	game_story_beat_requirements = default_gsb_requirements.duplicate()

func create_first_push_timer(timer_index : int, wait_time : float):
	cancel_and_restart_timer($FirstPushTimer, wait_time)
	
func create_repush_push_timer(timer_index : int, wait_time : float):
	cancel_and_restart_timer($RePushTimer, wait_time)

func cancel_repush_timer(timer_index : int):
	$RePushTimer.stop()


func _on_FirstPushTimer_timeout():
	handle_display_appslate(DisplayCondition.FIRSTTIMER)

func _on_RePushTimer_timeout():
	send_notification_to_phone()
	
func _on_game_story_beat_advanced(old_story_beat, old_frequency, new_story_beat, new_frequency):
	# ConversationEntryNode only cares about the story beat that was just resolved, not the new one
	# that the GameDaemon is looking for.
	evaluate_game_story_beat_requirements(old_story_beat, old_frequency)
	

# var app_parent = get_parent()
# takin a quick break get this connected to the GSB signals when it needs!

# Yes, I need to complete the signal flow here. Entry needs a way to figure out if the
# correct number of GSBs have already been sent out and, if not, have a way to bind to the
# gsb advancement signal in the text messanger. The reciever for that should mark the 
# GSB as being valid/recieved, then stop listening for the signal
# should it stop? maybe we just make it, like, not respond if its the wrong one,
# and if it never needs one we just ignore the signal when it does happen, but always
# listen?? hmm.
