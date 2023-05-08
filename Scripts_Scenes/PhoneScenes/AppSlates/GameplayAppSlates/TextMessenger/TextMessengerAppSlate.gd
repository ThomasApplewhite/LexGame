extends AppSlate


signal GameStoryBeatAdvanced(old_story_beat, old_frequency, new_story_beat, new_frequency)
var gsb_advanced_signal_name = "GameStoryBeatAdvanced" # setget , _get_gsb_advanced_signal_name

signal RequestGameStoryBeatFrequency(story_beat, requesting_entry)
var gsb_frequency_signal_name = "RequestGameStoryBeatFrequency" setget, _get_gsb_frequency_signal_name

var gsb_advanced_reciever_name = "_on_game_story_beat_advanced" setget , _get_gsb_advanced_reciever_name

func _get_gsb_advanced_reciever_name() -> String:
	return gsb_advanced_reciever_name
	
func _get_gsb_frequency_signal_name() -> String:
	return gsb_frequency_signal_name

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
