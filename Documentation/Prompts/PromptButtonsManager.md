# PromptButtonsManager
extends Control

PromptButtonsManager (in this doc as PBM) manages _all_ off the buttons for a phrase. Creating, freeing, and responding to which button is pressed are all the responsibility of the PBM, in addition to managing how quickly a phrase needs to be completed. A PBM is created by a PromptControl, and how its completion is interpreted is up to the PromptControl that created it. The PBM itself manages all its buttons through a row of PromptWordVBoxContainers (in this dock as PWVB), which spawn the buttons and provide info on whether or not the button pressed in a PWVB was the right one to press.

In short, PBMs manage every part of a Prompt that decides whether or not the player successfully completes a given phrase.

THERE NEEDS TO BE SOME SORT OF VISUAL FEEDBACK WHEN A PHRASE IS FAILED. SHOULD THE FIRST PHRASE RANDOMIZE ITS BUTTONS WHEN IT'S FAILED??

### Fields
word_box_scene : preloads the scene for PWVB

vBox_signal_name : the name of the signal to connect to to receive button press information from PWVB

vBox_signal_reciever : the name of the to call back when receiving the signal saved in vBox_signal_name

phrase_completed_signal_name : the name of the signal to emit when the phrase is over for whatever reason

current_word_in_phrase : how far along in the phrase the player has progressed, from 0 to the length of the phrase - 1

phrase_length : how long the current phrase is.

### Child Nodes
VBoxContainer : Organizer for subnodes of the scene (the HBoxContainer and ProgressBar)

VBoxContainer/HBoxContainer : UI Organizer for created PWVBs

VBoxContainer/ProgressBar : Visually represents the amount of remaining time to complete the phrase

Timer : Times how long the phrase has lasted so that it can fail if the player takes too long

## signal PhraseCompleted(completed_successfully : bool)
Emitted whenever a phrase is completed:
- When the PBM's timer runs out (sends false)
- When an 'incorrect' button is pressed (sends false)
- When the last 'correct' button is pressed, and there are no more PWVB left in this PBM (sends true)


## func _ready()
Hides the PBM on startup. That's really it. Phrase should really only be visual when it actually starts, right?

## func _process(_delta)
Sets the value remaining on the _ProgressBar_ to be the amount of time remaining on the timer.

## func init_prompt_buttons(signal_reciever : Node, signal_reciever_method : String, phrase : PromptPhrase):
Executes the following process:

1. Saves the length of _phrase.finished_phrase_
2. Sets the _Timer_ to _phrase.phrase_time_, and configures the _ProgressBar_ to scale is progress based off of the _Timer_ time limit.
3. Creates a new PWVB for each of the words in the phrase.
for _column_number_ in _phrase_length_ - 1:
	1. Save the column's correct word, which is _phrase.finished_phrase[column_number]_
	2. Calls **generate_word_column** to create a new PWVB. The PWVB is labeled with _column_number_, uses the saved column word for _column_word_, and spawns phrase.rows many buttons.
	3. Connects the _vBox_signal_name_ signal to the _vBox_signal_reciever_ method.
	4. Saves the created PWVB
4. Once all the PWVBs are created, parent them to the _HBoxContainer_ at the same time.
5. Connects the _phrase_completed_signal_name_ signal to the _signal_reciever_method_ function of the _signal_reciever_ object.

## func reset_prompt_buttons():
Restarts the _Timer_ associated with the phrase, and resets _current_word_in_phrase_ to 0. Note that this doesn't change button layouts, so the location of the correct buttons will stay the same. Will probably need to include a resetting of the button visuals too.


## func generate_word_column(column_number : int, correct_word : String, num_buttons : int) -> Control:
Instances a new PWVB, calls its **init_pwvbox(self, column_number, correct_word, num_buttons)**, and then returns the new PWVB.
	
## func handle_correct_column():
	# increase which word in the phrase we care about
	++current_word_in_phrase
	
	# if we're out of words in the phrase, pass the phrase
	if(current_word_in_phrase >= phrase_length):
		pass_phrase()

## func begin_phrase():
Starts the _Timer_ for the phrase and shows the PBM.
	
## func fail_phrase():
Stops the _Timer_ and emits the _phrase_completed_signal_name_ signal with 'false'

## func pass_phrase():
Stops the _Timer_ and emits the _phrase_completed_signal_name_ signal with 'true'

## func on_PromptWordVBoxContainer_ColumnComplete(completed_successfully : bool, col_num : int):
Callback for when a PWVB finishes. If the PWVB was completed successfully _and_ is the 'current' PWVB according to the PBM, calls **handle_correct_column**. If either of those things aren't true, calls **fail_phrase()**.

## func _on_Timer_timeout():
Callback for when the _Timer_ expires. Immediately fails the phrase.