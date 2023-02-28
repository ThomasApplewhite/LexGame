extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var phrase_scene = preload("res://Scripts_Scenes/PromptScenes/PromptButtonsManager/PromptButtonsManager.tscn")
var current_phrase
onready var life_tracker = $VBoxContainer/PromptLivesTrackerHBoxContainer

var prompt_settings : PromptSettings
var prompt_index : int = 0

signal PromptCompleted()
var prompt_completed_signal_name = "PromptCompleted"

var phrase_completed_signal_reciever = "_on_phrase_completed"

func init_prompt_control(finish_reciever_node, finish_reciever_method : String, settings : PromptSettings):
	
	# Step -1: Save the settings for later
	prompt_settings = settings
	
	# Step 0: Format the Prompt
	init_prompt_text(settings.prompt_text)
	
	# Step 1: Set up the lives
	init_lives_counters(settings.get_num_phrases())
	
	# Step 2: Connect signals to reciever
	init_signal_connections(finish_reciever_node, finish_reciever_method)
	
	# Step 3: Begin Managment of Phrases
	create_phrase(prompt_index)
	

func init_prompt_text(text : String):
	# Formatting will go here
	$VBoxContainer/RichTextLabel.bbcode_text = text
	pass
	
func init_lives_counters(lives_num : int):
	life_tracker.init_prompt_lives(lives_num)

func init_signal_connections(signal_reciever, reciever_method : String):
	connect(prompt_completed_signal_name, signal_reciever, reciever_method)
	
func create_phrase(phrase_index : int):
	# if a phrase already exists, get rid of it
	if(current_phrase):
		current_phrase.queue_free()
	
	# actually instance, init, and add the phrase
	current_phrase = phrase_scene.instance()
	current_phrase.init_prompt_buttons(self, phrase_completed_signal_reciever, prompt_settings.phrases[phrase_index])
	$VBoxContainer/ButtonsControl.add_child(current_phrase)
	current_phrase.begin_phrase()
	
	#the buttons handle gameplay from here, until we get a completion signal
	
func handle_phrase_finished(completed_successfully):
	if(completed_successfully):
		increment_prompt()
	else:
		decrement_prompt()
	
func increment_prompt():
	# Increment to the next phrase in the prompt
	prompt_index += 1
	
	# Are we past the last phrase in the prompt?
	if(prompt_index >= prompt_settings.get_num_phrases()):
		# If so, signal to owner that we're done here
		emit_signal(prompt_completed_signal_name)
	else:
		# If not, create a new prompt and increment the lives
		create_phrase(prompt_index)
	
	life_tracker.increment_marked_lives(1)

# I couldn't think of a good synonym for 'advance' as in 'advance the story'
func decrement_prompt():
	# If we're still on the first phrase...
	if(prompt_index <= 0):
		# just reset it
		current_phrase.reset_prompt_buttons()
	# if not...
	else:
		# decrement index and make a new phrase
		prompt_index -= 1
		create_phrase(prompt_index)
		life_tracker.increment_marked_lives(-1)
	
func _on_phrase_completed(completed_successfully : bool):
	handle_phrase_finished(completed_successfully)
