class_name AppSlate extends Control
# Because AppSlate is going to be so widely extended, it's gonna get class_name'd
# for obvious (and easy extention)



var back_button_handler_name = "_on_back_button_pressed" setget , _get_back_button_handler_name
var home_button_handler_name = "_on_home_button_pressed" setget , _get_home_button_handler_name
var opts_button_handler_name = "_on_opts_button_pressed" setget , _get_opts_button_handler_name

signal RequestNotification(appslate_type, notification_text)
var notification_signal_name = "RequestNotification" setget , _get_notification_signal_name

signal RequestAppSlateChange(appslate_type)
var slate_change_signal_name = "RequestAppSlateChange" setget , _get_slate_change_signal_name

signal GameStoryBeatTriggered(story_beat)
var story_beat_signal_name = "GameStoryBeatTriggered" setget , _get_story_beat_signal_name

var my_appslate_type setget _set_my_appslate_type, _get_my_appslate_type

# value : GameEnums.AppSlateType
func _set_my_appslate_type(value):
	my_appslate_type = value
	
# int hides return value as AppSlateType. Remember, Godot Enums are labeled ints.
func _get_my_appslate_type() -> int:
	return my_appslate_type

# These methods provide signals and signal names to receive phone button presses
# Actually connecting these is the phone's responsibility
# And all the getters are methods so they can be overridden as needed
func _get_back_button_handler_name() -> String:
	return back_button_handler_name
	
func _on_back_button_pressed():
	push_warning("AppSlate Back Button Pressed without implementation")
	
func _get_home_button_handler_name() -> String:
	return home_button_handler_name
	
func _on_home_button_pressed():
	push_warning("AppSlate Home Button Pressed without implementation")
	
# 'opts' is short for 'options' so they can all be 4 letters
func _get_opts_button_handler_name() -> String:
	return opts_button_handler_name
	
func _on_opts_button_pressed():
	push_warning("AppSlate Opts Button Pressed without implementation")
	
# As with the signals that AppSlates handles, the Phone is responsible for binding
# signals that AppSlates emit. So, easy signal names for those are important too
func _get_notification_signal_name() -> String:
	return notification_signal_name
	
func _get_slate_change_signal_name() -> String:
	return slate_change_signal_name
	
func _get_story_beat_signal_name() -> String:
	return story_beat_signal_name
