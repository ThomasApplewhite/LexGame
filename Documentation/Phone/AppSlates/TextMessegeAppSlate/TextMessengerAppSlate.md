# TextMessageAppSlate
extends AppSlate

The TextMessageAppSlate is responsible for displaying, updating, and organizing Lex's Text Messages. Most of the "game" of LexGame happens here.

TextMessageAppSlate, however, doesn't run actual conversations. That is the responsibility of ConversationEntryNode, ConversationAppSlate, and several other utility scripts and classes. Instead, TextMessageAppSlate is in charge of:
1. Communicating information between the conversations and the rest of the game (primarily the PhoneControl and the GameDaemon)
2. Visually organizing the different conversations in a list so Lex can choose who they want to talk to.

Right now (4/13/23), almost all of the TextMessageAppSlate is a stub. Only functionality required to make conversations has been implemented.

btw, _fields_ and _child nodes_ are _italics_, while **functions** and **signals** are **bold**.

### Fields
gsb_advanced_signal_name: Holds the name of the signal to emit whenever the required GameStoryBeat changes.

gsb_advanced_reciever_name: Holds the name of the method used to respond to signals regardng the GameStoryBeat advancing (but not this class' signal. This is mostly to respond to GameDaemon's GameStoryBeatAdvanced signal).

gsb_frequency_signal_name: Holds the name of the signal used to obtain GameStoryBeat frequency information from outside nodes.


### Child Nodes
DadConversatonEntry: ConversationEntryNode that handles texts with Dad.

MomConversatonEntry: ConversationEntryNode that handles texts with Mom.

TommyConversatonEntry: ConversationEntryNode that handles texts with Tommy. Hey, that's me!

All of these children have their ConversationEntryNodes connected to the matching receiver method in-editor.

## signal GameStoryBeatAdvanced(old_story_beat, old_frequency, new_story_beat, new_frequency)
story_beats are GameStoryBeats, frequencies are ints.

Emitted whenever the TextMessageAppSlate has been informed that the required GameStoryBeat has been updated.

## signal RequestGameStoryBeatFrequency(story_beat, requesting_entry)
story_beat is a GameStoryBeat, requesting_entry is a Node.

Emitte whenever the TextMessageAppSlate needs gsb_frequency info from a parent node (particularly, from GameDaemon).

## func _get_gsb_advanced_reciever_name() -> String:
Getter method for _gsb_advanced_reciever_name_. Returns _gsb_advanced_reciever_name_.

## func _get_gsb_frequency_signal_name() -> String:
Getter method for _gsb_frequency_signal_name_. Returns _sb_frequency_signal_name_.

## func _on_game_story_beat_advanced(old_story_beat, old_frequency : int, new_story_beat, new_frequency : int):
Signal reciever for GameStoryBeat advancement signals. Emits TextMessageAppSlate's own GSB advancment signal (whichever one is held in _gsb_advanced_signal_name_) with _old_story_beat_, _old_frequency_, _new_story_beat_, and _new_frequency_ as arguments. Yes, this method just passes the signal along. Nothing is done with it.

## func _on_notification_request_from_convo_entry(notification_text : String):
Reciever for the ConversationEntry's "RequestNotifcationWithText" signal. Immediately forwards the signal to the Phone using the _AppSlate. notificationSignalName_ signal. GameEnums.AppSlateType.TEXT is used for the AppSlateType and _notification_text_ is used for the text.

## func _on_gsb_frequency_info_request(requesting_node :  Node, story_beat):
_story_beat_ is a GameStoryBeat.

Emits the _gsb_frequency_signal_name_ signal, which will signal other nodes (namely, GameDaemon) to send the frequeny of _story_beat_ to _requesting_node_.

## func _on_game_story_beat_triggered(story_beat : int):
_story_beat_ is a GameStoryBeat

Emits the inherited AppSlate _story_beat_signal_name_ with _story_beat_ as the argument, to pass the GameStoryBeat up to the phone.