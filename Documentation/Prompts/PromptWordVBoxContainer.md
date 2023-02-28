# PromptWordVBoxContainer
extends VBoxContainer

PromptWordVBoxContainers manage an individual column of PromptWordButtons. The PromptWordButtons are instanced and setup by the PromptWordVBoxContainer. PromptWordButtons signal to the PromptWordVBoxContainer when they are pressed, and the container then signals out as to whether or not the 'correct' button was pressed.

And remember, PromptWordVBoxContainer _is_ a VBoxContainer. It will vertically contain its Control children. Which is the point, but still.

### Fields
button_signal: saves the name of the signal from the PromptWordButton to listen to

button_signal_reciever: saves the name of the method to connect to the PromptWordButton's signal

button_scene: preloads the PromptWordButton scene for later instancing

correct_button_num: the button number that, when clicked, will be counted as the 'correct' button in this column to press

column_complete_signal: saves the name of the signal the PromptWordVBoxContainer emits

column_number: this column's personal identifier. Provided during init.

## signal ColumnComplete(completed_successfully : bool, column_number : int)
Emitted whenever **_on_PromptWordButton_pressed** is called. Emits whether or not the _button_number_ function arg matches _correct_button_num_ (as a bool) as well as the Container's _column_number_

PromptWordButton

## func _ready()
Does nothing (for now)

## init_pwvbox(parent_controller : Node, parent_callback : String, assigned_number : int, correct_word : String, num_buttons : int)
That is to say, init_PromptWordVBoxContainer. Inits the Container by performing the following steps in order:

1: Save _assigned_number_ as the _column_number_ for self identification
2: Picks a button the be the correct button by **randi()** % _num_buttons_ and saves that to _correct_button_num_
3: Sets up each button number with this loop:
for _button_num_ in _num_buttons_ - 1:
	1: Creates a PromptWordButton in _new_button_ using the _button_scene_
	2: Sets _new_button.word_num_ to _button_num_
	3: Sets the _new_button_word_ to be either _correct_word_ if the _button_num_ is _correct_button_num_ or "TBD" if it isn't
	4: Calls _new_button.set_label_word(new_button_word)_ to init the PromptWordButton
	5: Uses _button_signal_ and _button_signal_reciever_ to connect the PromptWordButton's **_on_PromptWordButton_pressed** signal to the container's **_on_PromptWordButton_pressed** method.
	6: Adds the _new_button_ as a child of the PromptWordVBoxContainer
4: Connects the _parent_controller_ _parent_callback_ to _column_complete_signal_

## func _on_PromptWordButton_pressed(button_number : int)
Emits the signal stored in column_complete_signal, returning whether or not _button_number_ equals _correct_button_num_ and the PromptWordVBoxContainer