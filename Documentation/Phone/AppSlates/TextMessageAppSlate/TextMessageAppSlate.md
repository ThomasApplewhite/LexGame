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

### Child Nodes
DadConversatonEntry: ConversationEntryNode that handles texts with Dad.

MomConversatonEntry: ConversationEntryNode that handles texts with Mom.

TommyConversatonEntry: ConversationEntryNode that handles texts with Tommy. Hey, that's me!

## signal GameStoryBeatAdvanced(old_story_beat, old_frequency, new_story_beat, new_frequency)
story_beats are GameStoryBeats, frequencies are ints.

Emitted whenever the TextMessageAppSlate has been informed that the required GameStoryBeat has been updated.

## func _get_gsb_advanced_reciever_name() -> String:
Getter method for _gsb_advanced_reciever_name_. Returns _gsb_advanced_reciever_name_.

## func _on_game_story_beat_advanced(old_story_beat, old_frequency : int, new_story_beat, new_frequency : int):
Signal reciever for GameStoryBeat advancement signals. Emits TextMessageAppSlate's own GSB advancment signal (whichever one is held in _gsb_advanced_signal_name_) with _old_story_beat_, _old_frequency_, _new_story_beat_, and _new_frequency_ as arguments. Yes, this method just passes the signal along. Nothing is done with it.