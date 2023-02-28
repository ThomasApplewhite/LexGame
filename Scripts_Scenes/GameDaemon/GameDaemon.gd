extends Node

var messanger_appslate

func _ready():
	get_messanger_appslate()
	
func get_messanger_appslate():
	messanger_appslate = $PhoneControl.appslate_dict[GameEnums.AppSlateType.TEXT]

# This will evaluate story beats when we get there, don't worry about it.
func _on_game_story_beat_triggered(story_beat):
	pass
