extends AppSlate


signal GameStoryBeatAdvanced(story_beat, frequency)
var gsb_advanced_signal_name = "GameStoryBeatAdvanced" # setget , _get_gsb_advanced_signal_name

var gsb_advanced_reciever_name = "_on_game_story_beat_advanced" setget , _get_gsb_advanced_reciever_name

func _get_gsb_advanced_reciever_name() -> String:
	return gsb_advanced_reciever_name

func _on_game_story_beat_advanced(story_beat, story_beat_frequency: int):
	emit_signal(gsb_advanced_signal_name, story_beat, story_beat_frequency)
