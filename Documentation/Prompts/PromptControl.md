# PromptControl
extends Control

A PromptControl is the root node of a Prompt gameplay element, so named because it controls the entirety of the prompt's functionality _and_ because it's a Control Node.

Once created, a PromptControl spawns and manages every part of the Prompt.

_this also isn't all the way done yet_

NOTE: PromptControls need to be added to the SceneTree _before_ they're initialized, since initializing starts the timer of the first phrase's PromptButtonsManager

### Fields
field: purpose

phrase_scene: The scene of the PromptButtonManager to generate.

current_phrase: The PromptButtonsManager that the PromptControl is currently handling.

life_tracker: onready saves the _PromptLivesTrackerHBoxContainer_ for easier reference later

prompt_settings: saves the prompt settings object that this PromptContol is running gameplay for.

prompt_index: the index of the current phrase being displayed in the prompt.

prompt_completed_signal_name: saves the name of the signal to be emitted when the prompt is completed.

phrase_completed_signal_reciever: saves the name of the signal the PromptControl should listen to from its PromptButtonsManagers to decide when to move on the the next phrase.

### Child Nodes
VBoxContainer: Used to organize the operative subcontrols/nodes of the PromptControl

VBoxContainer/RichTextLabel: Holds the static text of the Prompt

VBoxContainer/ButtonsControl: Designated parent of the PromptButtonsManager the PromptControl will generate. Having a designated parent guarantees the PromptButtonsManager's position in the VBoxContainer

VBoxContainer/PromptLivesTrackerHBoxContainer: Tracks the progress/lives of PromptControl visually

## signal PromptCompleted()
Emitted whenever the PromptControl is finished. Because the PromptControl only ends itself when the prompt is passed, there is no 'fail' signal. Ending the prompt for reasons other than completing it are up to outside nodes. 

## func function(arg : arg_type)
Summary of the function's args and what it does

## func init_prompt_control(finish_reciever_node, finish_reciever_method : String, settings : PromptSettings):
Initializes the PromptControl, taking the following steps in order:
	
1. Saving the incoming _settings_ to _prompt_settings_ 
2. Initialize the prompt's static text in **init_prompt_text(_settings.prompt_text_)**
3. Initialize the _PromptLivesTrackerHBoxContainer_ with **init_lives_counters(_settings.get_num_phrases()_)**
4. Connect signals to the PromptControl's parent with **init_signal_connections(_finish_reciever_node_, _finish_reciever_method_)**
5. Actually start the prompt with **create_phrase(_prompt_index_)**

The important thing to keep in mind here is that this method starts PromptControl gameplay in addition to setting everything up.
	

## func init_prompt_text(text : String):
Will be responsible for text formatting. For now, just applies _text_ to the _Rich_Text_Label_

## func init_lives_counters(lives_num : int):
Initializes the _PromptLivesTrackerHBoxContainer_ with _life_tracker_.**init_prompt_lives(lives_num)**

## func init_signal_connections(signal_reciever, reciever_method : String):
**connect(prompt_completed_signal_name, signal_reciever, reciever_method)**

That' it.
	
## func create_phrase(phrase_index : int):
Frees out any existing PromptButtonsManagers stored in _current_phrase_, then instances, inits (**current_phrase.init_prompt_buttons(self, phrase_completed_signal_reciever, prompt_settings.phrases[phrase_index])
	$VBoxContainer/ButtonsControl.add_child(current_phrase)**), parents, and starts (**current_phrase.begin_phrase()**) the phrase.

The thing to keep in mind is that the PromptButtonsManager needs to be parented before being started. The Timer in the PromptButtonsManager needs to be in the scene tree before starting, and it starts in **begin_phrase()**
	
## func handle_phrase_finished(completed_successfully):
**increment_prompt()** if _completed_successfully_ is true, otherwise **decrement_prompt()**
	
## func increment_prompt():
Increments _prompt_index_ by 1.

If that means we're out of phrases in the prompt, the signal in _prompt_completed_signal_name is emitted. If we still have phrases to go, the next phrase is created with **create_phrases(prompt_index)**

Finally, the _life_tracker_ is incremented by 1 with **life_tracker.increment_marked_lives(1)**

## func decrement_prompt():
If the PromptControl is still on the first phrase (_prompt_index_ is 0), reset the _current_phrase_ with **current_phrase.reset_prompt_buttons()**

If it isn't, decrease _prompt_index_ by 1, create a new phrase with **create_phrase(prompt_index)**, and decrement _life_tracker_ by 1 with **life_tracker.increment_marked_lives(-1)**
	
## func _on_phrase_completed(completed_successfully : bool):
Receiver for the phrase completion signal in _current_phrase_. calls **handle_phrase_finished(completed_successfully)**
