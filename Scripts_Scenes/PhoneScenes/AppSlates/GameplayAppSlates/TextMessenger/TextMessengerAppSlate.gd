extends AppSlate


signal GameStoryBeatAdvanced(old_story_beat, old_frequency, new_story_beat, new_frequency)
var gsb_advanced_signal_name = "GameStoryBeatAdvanced" # setget , _get_gsb_advanced_signal_name

var gsb_advanced_reciever_name = "_on_game_story_beat_advanced" setget , _get_gsb_advanced_reciever_name

func _get_gsb_advanced_reciever_name() -> String:
	return gsb_advanced_reciever_name

func _on_game_story_beat_advanced(old_story_beat, old_frequency : int, new_story_beat, new_frequency : int):
	emit_signal(gsb_advanced_signal_name, old_story_beat, old_frequency, new_story_beat, new_frequency)

# When a convo_entry requests a notification signal, pass it along to the phone
func _on_notification_request_from_convo_entry(notification_text : String):
	emit_signal(notification_signal_name, GameEnums.AppSlateType.TEXT, notification_text)
