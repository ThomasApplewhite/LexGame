# PhoneControl
extends Control

Class Description
Represents Lex's Phone. The PhoneControl places and arranges AppSlates, and has buttons (Home, Back, Options) that the player can use for AppSlate-agnostic navigation. 


The PhoneControl's primary purpose is to send navigation signals to AppSlates (home, back, options) and to receive signals from AppSlates (change appslate, GameStoryBeat occured, and notification). PhoneControl also implements responses to the signals it receives: it processes appslate changes, pushes notification visuals/text onto the phone screen, and passes GameStoryBeat signals along to the GameDaemon

btw, _fields_ and _child nodes_ are _italics_, while **functions** and **signals** are **bold**.

### Fields
export active_app_control_nodepath: A nodepath pointing to the Control that the active AppSlate should parent to.

export inactive_app_control_nodepath: A nodepath pointing to the Control that inactive AppSlates should parent to.

var active_app_control: The Control that the active AppSlate should parent to.

var inactive_app_control: The Control that inactive AppSlates should parent to.

export appslate_path_dict:  An int->NodePath dict that associates an int (which represents a GameEnums.AppSlateType) with a path to a prexisting AppSlate node.

export starting_appslate_type: An int (which represents a GameEnums.AppSlateType) that indicates which type of AppSlate the game should start.

appslate_dict: A GameEnums.AppSlateType->Control dict that associates each of the phone's AppSlates with an AppSlateType for easy referencing. 

current_appslate: The current AppSlate being displayed by the PhoneControl.

back_button_signal_name: The name of the signal to emit when the phone's back button is pressed.

home_button_signal_name: The name of the signal to emit when the phone's home button is pressed.

opts_button_signal_name: The name of the signal to emit when the phone's options button is pressed.

story_beat_signal_name: The name of the signal to emit when the phone receives a GameStoryBeat from an AppSlate.

appslate_handler_name: The name of the method to call when the phone receives a change appslate signal from an AppSlate.

notification_handler_name: The name of the method to call when the phone receives a push notification signal from an AppSlate.

storybeat_handler_name: The name of the method to call when the phone receives a GameStoryBeat occurance signal from an AppSlate.


### Child Nodes
InactiveAppSlateControl: The anchoring parent Control for any inactive AppSlates. Only needs to make sure the AppSlates stay offscreen, no other arranging is necessary.

InactiveAppSlateControl/HomeScreenAppSlate: The phone's Home Screen.

InactiveAppSlateControl/TextMessengerAppSlateControl: Confusing, right? The phone's Messenging App.

VisualAssetControl: Parent controller for visual assets and position-sensitive parts of the Phone.

VisualAssetControl/PhoneBackgroundColor: Background/frame visual for the whole phone. Right now just a color rect.

VisualAssetControl/PhoneBackgroundColor: Background visual for the phone screen. Right now just a color rect.

VisualAssetControl/PhoneBackgroundColor/ActiveAppSlateControl: The anchoring parent Control for the _current_appslate_. Used to keep the _current_appslate_ centered and in the middle of the Phone's frame.

VisualAssetControl/ButtonColorRect: Background visual for the phone's buttons. Right now just a color rect.

VisualAssetControl/ButtonColorRect/HBoxController: Visually organizes the PhoneControl's 3 non-AppSlate buttons.

VisualAssetControl/ButtonColorRect/HBoxController/BackButton: The UI button used to navigate 'back' on the phone. What that means is AppSlate-dependent.

VisualAssetControl/ButtonColorRect/HBoxController/BackButton/Label: The text of the _BackButton_.

VisualAssetControl/ButtonColorRect/HBoxController/HomeButton: The UI button used to navigate 'home' on the phone. Technically AppSlate-dependent, but should always change the _current_appslate_ to the Home AppSlate, if that isn't what it already is. If the Home AppSlate is the _current_appslate_, nothing will happen.

VisualAssetControl/ButtonColorRect/HBoxController/HomeButton/Label: The text of the _HomeButton_.

VisualAssetControl/ButtonColorRect/HBoxController/OptsButton: The UI button used to use options on the phone's current AppSlate. What that means is AppSlate-dependent, and I haven't decided on what it will be used for.

VisualAssetControl/ButtonColorRect/HBoxController/OptsButton/Label: The text of the _OptsButton_.

There will also be several more child nodes: one node for each AppSlate. But those haven't been made yet, so don't worry about it for now.

## signal BackButtonPressed()
Emitted when the _HBoxController/BackButton_ **_on_BackButton_pressed()** signal is received. Emitted to communicate button presses to AppSlates.

## signal HomeButtonPressed()
Emitted when the _HBoxController/HomeButton_ **_on_HomeButton_pressed()** signal is received. Emitted to communicate button presses to AppSlates.

## signal OptsButtonPressed()
Emitted when the _HBoxController/OptsButton_ **_on_OptsButton_pressed()** signal is received. Emitted to communicate button presses to AppSlates.

## signal StoryBeatTriggered(story_beat)
Emitted when a child AppSlate sends an **_on_game_story_beat_triggered(story_beat)** signal to the phone. Emitted to pass the _story_beat_ along to the GameDaemon (or any other listener, for that matter.

## func _ready()
Sets _active_app_control_ and _inactive_app_control_ to the nodes held in _active_app_control_nodepath_ and _inactive_app_control_nodepath_ respectively. Then calls **initialize_appslates()**.

## func initialize_appslates():
Connects basic signals to each AppSlate (from all the paths in _appslate_path_dict_) and sets its internal my_appslate_type (using the AppSlate's respective _appslate_path_dict_ key). This is how all of the AppSlate nodes get placed into _appslate_dict_.

Once all AppSlates are initialized, _appslate_dict[starting_appslate_type]_ has all of its signals connected and is then made the active AppSlate. This is done with logic identical to the activating logic in **change_active_appslate()**.

## func change_active_appslate(new_appslate_type):
new_appslate_type is type GameEnums.AppSlateType, but can't be typed that way. See GameEnums.md for more info on why.

Switches out the _current_appslate_ (which is re-saved as _old_appslate_) for _appslate_dict[_new_appslate_type_]_. This is done by diconnecting _old_appslate_ signals (using **disconnect_appslate_signals(old_appslate, false)**) and connecting _new_appslate_ signals (using **connect_appslate_signals(new_appslate, false)**). Both of these method are called with 'false' to keep their notification and storybeat signals connected and untouched, which is currently desired.

Then, the _old_appslate_ is reparented to the _inactive_app_control_ and the _new_appslate_ is reparented to the _active_app_control_ and moved to the same _global_rect_position_ as the _active_app_control_ by setting the _new_appslate_ _rect_position_ to 0, 0.

Once all the transfering is complete, _new_appslate_ is saved as the _current_appslate_.

## func connect_appslate_signals(appslate, connect_beat_and_notif : bool):
Connects the following signals from PhoneControl to _appslate_, using the respective handler name from the _appslate_ for the receiver method:
1. _back_button_signal_name_ -> _appslate.back_button_handler_name_
2. _home_button_signal_name_ -> _appslate.home_button_handler_name_
3. _opts_button_signal_name_ -> _appslate.opts_button_handler_name_

And connect's the _appslate.slate_change_signal_name_ to the PhoneControl using _appslate_handler_name_ as the receiver.

If _connect_beat_and_notif_ is True, this method also calls **connect_mandatory_signals(appslate)**

This conditional is only needed if connecting a signal that is already connected causes an error, since these signals may already be connect. If that doesn't happen, then these signals can be handled with the slate change signal connection.
	
## func disconnect_appslate_signals(appslate, disconnect_beat_and_notif : bool):
Disconnects the following signals from PhoneControl to _appslate_, using the respective handler name from the _appslate_ for the receiver method:
1. _back_button_signal_name_ -> _appslate.back_button_handler_name_
2. _home_button_signal_name_ -> _appslate.home_button_handler_name_
3. _opts_button_signal_name_ -> _appslate.opts_button_handler_name_

And disconnect's the _appslate.slate_change_signal_name_ to the PhoneControl using _appslate_handler_name_ as the receiver.

If _disconnect_beat_and_notif_ is True, this method also calls **disconnect_mandatory_signals(appslate)**

This conditional is needed because I haven't made up my mind if inactive AppSlates should send these signals. Inactive AppSlates should probably always send Notifications, but I'm not sure about GameStoryBeats. But with this conditional, I can decide that later.

## func connect_mandatory_signals(appslate):
Connects the following appslate signals to PhoneControl, with the respective handler names for the receiver method.

1. _appslate.notification_signal_name_ -> _notification_handler_name_
2. _appslate.notification_signal_name_ -> _storybeat_handler_name_
	
## func disconnect_mandatory_signals(appslate):
Disconnects the following appslate signals from PhoneControl, with the respective handler names for the receiver method.

1. _appslate.notification_signal_name_ -> _notification_handler_name_
2. _appslate.notification_signal_name_ -> _storybeat_handler_name_

# The following Methods are only used for signal handling

## func _on_appslate_change_requested(appslate_type):
appslate_type is type GameEnums.AppSlateType, but can't be typed that way. See GameEnums.md for more info on why.

Signal receiver for AppSlate-originated AppSlate change requests. Calls **change_active_appslate(appslate_type)**

## func _on_phone_notification_triggered(appslate_type, notif : String):
appslate_type is type GameEnums.AppSlateType, but can't be typed that way. See GameEnums.md for more info on why.

Signal receiver for AppSlate-originated push notification requests. Currently does nothing, since push notifications haven't been implemented yet.
	
## func _on_game_story_beat_triggered(story_beat):
appslate_type is type GameEnums.GameStoryBeat, but can't be typed that way. See GameEnums.md for more info on why.

Signal receiver for AppSlate-originated GameStoryBeat occurances requests. Emits the _story_beat_signal_name_ signal with _story_beat_ as its argument.

## func _on_BackButton_pressed():
Signal receiver for _HBoxController/BackButton_ **_on_pressed()**. Emits the _back_button_signal_name_ signal.

## func _on_HomeButton_pressed():
Signal receiver for _HBoxController/HomeButton_ **_on_pressed()**. Emits the _home_button_signal_name_ signal.

## func _on_OptsButton_pressed():
Signal receiver for _HBoxController/OptsButton_ **_on_pressed()**. Emits the _opts_button_signal_name_ signal.
