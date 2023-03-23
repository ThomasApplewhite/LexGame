extends Node

enum DisplayCondition {
	FIRSTTIMER,
	STORYBEAT
}

var default_display_conditions = {
	DisplayCondition.FIRSTTIMER : false,
	DisplayCondition.STORYBEAT : true # this should be false
}

# STILL NEEDS STORY BEAT HANDLING

# needs to hold convo asset and convo slate type and convo slate itself
export var conversation_resource : Resource
var convo_slate_scene = preload("res://Scripts_Scenes/PhoneScenes/AppSlates/GameplayAppSlates/TextMessenger/ConversationAppSlate.tscn")
var convo_slate : Node

# Convo-Slate State Variables
var do_next_convo = default_display_conditions
var convo_slate_is_active : bool setget , _get_convo_slate_is_active
var last_displayed_chunk_text : String = ""
var last_displayed_chunk_index : int = -1

func create_conversation_slate():
	convo_slate = convo_slate_scene.instance()
	convo_slate.initialize_convo_slate(conversation_resource, self, last_displayed_chunk_index)
	add_child(convo_slate)
	convo_slate.start_convo_slate()
	convo_slate_is_active = true
	
func remove_conversation_slate():
	last_displayed_chunk_index = convo_slate.end_convo_slate()
	
	convo_slate.queue_free()
	
	convo_slate_is_active = false
	
func _get_convo_slate_is_active() -> bool:
	return convo_slate_is_active

# --- TIMER HANDLING ---

func cancel_and_restart_timer(timer : Node, wait_time : float):
	timer.stop()
	timer.wait_time = wait_time
	timer.start()
	
func send_notification_to_phone():
	# Only send notifications for this conversation if they aren't being looked at right now
	if(convo_slate_is_active):
		return
		
	# ConversationEntry is only ever a child of TextMessangerAppSlate, so...
	var app_parent = get_parent()
	var app_parent_notif = app_parent.notification_signal_name
	# Emit the notif signal, and we're good to go!
	app_parent.emit_signal(app_parent_notif, GameEnums.AppSlateType.TEXT, last_displayed_chunk_text)

func handle_display_appslate(display_condition : int):
	do_next_convo[display_condition] = true
	var ready = do_next_convo[DisplayCondition.FIRSTTIMER] && do_next_convo[DisplayCondition.STORYBEAT]
	
	# if it's not time to display the next part of the conversation, don't.
	if(!ready):
		return
	
	# if the convo slate isn't active, just advance the current convo index and don't display anything
	if(!convo_slate_is_active):
		last_displayed_chunk_index += 1
		return
	
	# If we are ready, display the text (or prompt), send a notif, and reset the display conditions
	last_displayed_chunk_text = convo_slate.handle_next_convo_dict()
	
	send_notification_to_phone()
	
	do_next_convo = default_display_conditions

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
