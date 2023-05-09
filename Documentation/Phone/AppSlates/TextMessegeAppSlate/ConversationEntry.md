# ConversationEntry
extends Node

ConversationEntry nodes are non-graphical parents between the TextMessageAppSlate and a specific ConversationAppSlate. ConversationEntries handle all non-graphical functionality of a ConversationAppSlate that needs to persist while the ConversationAppSlate isn't focused (as, right now, ConversationAppSlates are free'd when not being focused on). This primarily involves keeping track of the ConversationAppSlate's timers and last active conversation piece, so that the state of the conversation can be restored when reopened.

ConversationEntries are Nodes, not Controls, because they have no UI-related functionality ore responsibility. But if that makes ConversationAppSlates hard to position, they should be turned into Controls.

btw, _fields_ and _child nodes_ are _italics_, while **functions** and **signals** are **bold**.

### Fields
enum DisplayCondition: Represents which of the two conditions that a conversation dict needs to meet (FIRSTTIMER: its first notification was sent and STORYBEAT: its associated GameStoryBeat has occured) before its displayed onscreen. This can be represented by a bool right now, but an enum felt cleaner.

enum GSBRequirement: Represents which GameStoryBeat needs to be occur (and how many times it needs to occur) before the upcoming conversation chunk can be displayed.

const default_display_conditions: A dict to hold what the "waiting for everything" state of do_next_convo is, see below.

const default_gsb_requirements: A dict to hold what the "we have no requirements right now" state of game_story_beat_requirements is, see below.

export conversation_resource: Resource file of the ConversationJSONData this conversation uses. This is where the final JSONDatas are set; other Nodes (like the ConversationAppSlate) get the JSONData from here.

convo_slate_scene: Resource path for the ConversationAppSlate

convo_slate: Reference to the ConversationAppSlate, once it gets instanced.

notif_with_text_signal_name: Holds the name of the signal to be emitted when the ConversationEntry wants to cause a phone notification.

request_frequency_signal_name: Holds the name of the signal to be emitted when the ConversationEntry wants to know how many time a GameStoryBeat has already occurred.

story_beat_signal_name: Holds the name of the signal to be emitted when the ConversationEntry wants to tell other Nodes that its conversation has sent a GameStoryBeat (so that the number of GSB occurances can be increased).

gsb_advanced_reciever_name: Holds the name of the method that will recieve GameStoryBeatAdvanced signals from other classes. Comes with a getter for easy out-of-class access.

do_next_convo: A dictionary representing the multiple conditions required to 'do the next' (display on screen and parse the next piece of) conversation. A smarter man could make this a bitmask, but I have it as a dict of enums for right now. Who knows, maybe it will be a bitmask one day.

game_story_beat_requirements: A dictionary that holds the GameStoryBeat and frequency of that story beat that needs to be recieved before the currently held convo_slate can be displayed.

convo_slate_is_active: Is the ConversationAppSlate currently instanced or not. This controls certain notifications which don't occur if the Conversation is already being displayed.

last_displayed_chunk_text: The most recent conversation partner message from this conversation. This is displayed as part of most notifications for right now.

last_displayed_chunk_index: The index of most recent conversation partner message from this conversation. This is used to 'fast forward' the ConversationAppSlate to the last displayed conversation piece whenever it gets opened.

### Child Nodes
FirstPushTimer: Pre-generated one-shot timer for the first notification a conversation piece always sends.

RePushTimer: Pre-generated repeat timer for repeated notifications pushed by messages that contain Prompts that must be completed.

## signal RequestNotificationWithText(notification_text):
_notification_text_ is a String.

Emitted whenever a ConversationEntry wants the TextMessageAppSlate to send a notification, usually recieved by the textMessageAppSlate itself. Because the TextMessageAppSlate handles the actual notification signal (since it's an Appslate) the only thing the ConversationEntry needs to provide is the text of the notification.

## signal RequestGSBFrequencyInfo(requesting_convo_entry, story_beat):
_requesting_convo_entry_ is a Node, _story_beat_ is a GameStoryBeat.

Emitted whenever a new required GameStoryBeat is set and the ConversationEntry needs to know how many times it has already happened. The reciever (which will be a TextMessageAppSlate) will call **evaluate_game_story_beat_requirements(story_beat, [whatever the frequency is])** to inform the ConversationEntry of what the frequency is.

## func create_conversation_slate():
Instances the ConversationAppSlate into _convo_slate_, adds it to the node tree, and starts it. Other setup that needs to happen with the _convo_slate_ should be done here. Oh, and this is the method to call when the _convo_slate_ should be shown. Keep in mind that _convo_slate_ needs to be added to the tree first, before its initialized, to make sure all of its subnodes initialize
 	
## func remove_conversation_slate():
Calls **convo_slate.end_convo_slate()** to get the index of the most recent conversation dict and save it to _last_displayed_chunk_index_. **end_convo_slate()** also does _convo_slate_'s internal shutdown/teardown logic. Once that's done, the _convo_slate_ is freed and set to null.

## func _get_convo_slate_is_active() -> bool:
Getter funcion for _convo_slate_is_active_. Returns true if _convo_slate_ is not null and **convo_slate.is_inside_tree()** is true.

## func cancel_and_restart_timer(timer : Node, wait_time : float):
Generic timer-restarting method. Stops the provided _timer_, sets its _timer.wait_time_ to _wait_time_, and starts it back up again. Since each ConversationEntry handles multiple timers, it's good to centralize how all the timers are started and stopped.
	
## func send_notification_to_phone():
If _convo_slate_is_active_ is false, emits the signal held in var _notif_with_text_signal_name_ with _last_displayed_chunk_text_ as the argument.

## func handle_display_appslate(display_condition : int):
_display_condition_ is actually a DisplayCondition enum.

Takes the incoming display condition and adds it to _do_next_convo_ as 'True'. If that makes both conditions of _do_next_convo_ true, then the following things occur:
	1. The ConversationEntry will emit the signal in _story_beat_signal_name_ with **convo_slate.get_current_convo_dict_send_story_beat()** as the argument. This informs the rest of the game of the GSB that just occured from this conversation chunk completing.
	2. _do_next_convo_ and _game_story_beat_requirements_ are reset to their defaults with **reset_conditional_dicts()**
	3. Tell the _convo_slate_ to **handle_next_convo_dict()**, which will take care of displaying the actual conversation.
	4. Sends a notification with **send_notification_to_phone()**.

If both conditions of _do_next_convo_ are true, but the _convo_slate_ isn't active, this method will increment _last_displayed_chunk_index_ by 1 instead of doing step 3.

## func create_game_story_beat_requirements(required_gsb, required_frequency : int):
_required_gsb_ is a GameStoryBeat.

If _required_gsb_ has already occurred at _required_frequency_ (which is always false right now, as determining that hasn't been implemented yet), sets _do_next_convo[DisplayCondition.STORYBEAT]_ to "true" and returns.

If it hasn't, _game_story_beat_requirements_ is populated with that information to be checked later against incoming GSB signals.

## func evaluate_game_story_beat_requirements(story_beat, story_beat_frequency : int):
_story_beat_ is a GameStoryBeat.

Checks the incoming _story_beat_ and _story_beat_frequency_ against the GSB and frequency held in _game_story_beat_requirements_. If both match, calls **handle_display_appslate(DisplayCondition.STORYBEAT)** to inform the ConversationEntry that the StoryBeat part of the display requirements is fulfilled.

## func reset_conditional_dicts():
Restores _do_next_convo_ and _game_story_beat_requirements_ to their default states so they can do conditions for a new conversation chunk. These defaults are a duplicate of _default_display_conditions_ and _default_gsb_requirements_.

## func create_first_push_timer(timer_index : int, wait_time : float):
Calls **cancel_and_restart_timer(FirstPushTimer, wait_time)**. Called 'create' because it originally created the timer, and takes an index for reasons I don't remember. Maybe I should change that...
	
## func create_repush_push_timer(timer_index : int, wait_time : float):
Calls **cancel_and_restart_timer(RePushTimer, wait_time)**. Called 'create' because it originally created the timer, and takes an index for reasons I don't remember. Maybe I should change that...

## func cancel_repush_timer(timer_index : int):
Tells _RePushTimer_ specifically to stop.

## func _on_FirstPushTimer_timeout():
Timeout handler for _FirstPushTimer_. Calls **handle_display_appslate(DisplayCondition.FIRSTTIMER)** to display the next conversation piece, if the correct story beat has happened.

## func _on_RePushTimer_timeout():
Timeout handler for _RePushTimer_. Calls **send_notification_to_phone()** to send repeat notifications for prompts.

## func _on_game_story_beat_advanced(old_story_beat, old_frequency, new_story_beat, new_frequency):
Signal reciever for GSB-update-related signals. Calls **evaluate_game_story_beat_requirements(old_story_beat, old_sfrequency)** to see if the newly recieved _old_story_beat_ and _old_frequency_ will fulfill any display conditions.