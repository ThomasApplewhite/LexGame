# AppSlate
extends Control

Represents apps on Lex's phone, specifically by being extended for each kind of unique app. What each derived appslate does and how each derived appslate is laid out is child-specific (and isn't covered here), but the AppSlate baseclass they all share handle general interactions with the phone.

An AppSlate's primary purpose is to interface with the PhoneControl by sending signals (GameStoryBeats occuring, notifications, requests to change appslates) and receiving signals (home button presses, back button presses, option button presses).

To fit Lex's 9:20 GalaxyS20 in the game's 4:3 720 x 480 Screen, Appslates should be 207 x 420 pixels. That's not quite 9:20 but it fits on the screen well.

btw, _fields_ and _child nodes_ are _italics_, while **functions** and **signals** are **bold**.

### Fields
back_button_handler_name: Name of the receiver method for the PhoneControl's BackButtonPressed signal.

home_button_handler_name: Name of the receiver method for the PhoneControl's HomeButtonPressed signal.

opts_button_handler_name: Name of the receiver method for the PhoneControl's OptsButtonPressed signal.

notification_signal_name: Name of the signal to send when the AppSlate wants to push a notification to the phone.

slate_change_signal_name: Name of the signal to send when the AppSlate wants to change to a different AppSlate.

story_beat_signal_name: Name of the signal to send when the AppSlate wants to report a completed GameStoryBeat.

my_appslate_type: The GameEnums.AppSlateType that this AppSlate is described by, 'cause I trust enum type association more than duck typing lol.

## signal RequestNotification(appslate_type, notification_text)
Emitted when the AppSlate wants to push a notification to the phone. Includes the type of the appslate sending it (_appslate_type_) and what the notification should say (_notification_text_)

## signal RequestAppSlateChange(appslate_type)
Emitted when the AppSlate wants to transition to a new AppSlate. _appslate_type_ is the type of the AppSlate being transitioned to.

## signal GameStoryBeatTriggered(story_beat)
Emitted when the AppSlate completes a GameStoryBeat. Whether or not anything should happen when that GameStoryBeat is sent depends on the receiver. GameStoryBeats can be sent multiple times from the same AppSlate.

## func _set_my_appslate_type(value):
my_appslate_type = value
_value_ is a GameEnums.AppSlateType

## func _get_my_appslate_type() -> int:
return my_appslate_type
This function returns an int because it's the closest I can get to returning an GameEnums.AppSlateType.

# The following Methods are getters for their respectively named fields. They may be overriden by child classes.

## func _get_back_button_handler_name() -> String:
return back_button_handler_name

## func _get_home_button_handler_name() -> String:
return home_button_handler_name

## func _get_opts_button_handler_name() -> String:
return opts_button_handler_name

'opts' is short for 'options' so they can all be 4 letters

## func _get_notification_signal_name() -> String:
return notification_signal_name
	
## func _get_slate_change_signal_name() -> String:
return slate_change_signal_name
	
## func _get_story_beat_signal_name() -> String:
return story_beat_signal_name

# The following Methods are only used for signal handling. They are designed to be overridden by child classes, and by default do nothing.

## func _on_back_button_pressed():
Receives BackButtonPressed signals from PhoneControl.
	
## func _on_home_button_pressed():
Receives HomeButtonPressed signals from PhoneControl.
	
## func _on_opts_button_pressed():
Receives HomeButtonPressed signals from PhoneControl.