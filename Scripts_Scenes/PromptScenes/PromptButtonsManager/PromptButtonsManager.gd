extends Control

var word_box_scene = preload("res://Scripts_Scenes/PromptScenes/PromptWordVBoxContainer/PromptWordVBoxContainer.tscn")

# var vBox_signal_name = "ColumnComplete"
var vBox_signal_reciever = "on_PromptWordVBoxContainer_ColumnComplete"

signal PhraseCompleted(completed_successfully)
var phrase_completed_signal_name = "PhraseCompleted"

var current_word_in_phrase = 0
var phrase_length

# Called when the node enters the scene tree for the first time.
func _ready():
	# Hide the phrases on startup
	self.hide()
	
func _process(_delta):
	$VBoxContainer/ProgressBar.value = $Timer.time_left

func init_prompt_buttons(signal_reciever : Node, signal_reciever_method : String, phrase : PromptPhrase):
	var prepared_buttons = []
	var column_word
	var new_box
	
	phrase_length = len(phrase.finished_phrase)
	
	# set up timer
	$Timer.wait_time = phrase.phrase_time
	$VBoxContainer/ProgressBar.min_value = 0
	$VBoxContainer/ProgressBar.max_value = phrase.phrase_time
	
	# set up each columns
	for column_number in phrase_length:
		column_word = phrase.finished_phrase[column_number]
		new_box = generate_word_column(column_number, column_word, phrase.rows)

		prepared_buttons.append(new_box)
		
	# once all the columns are created, parent them at the same time
	for word_box in prepared_buttons:
		$VBoxContainer/HBoxContainer.add_child(word_box)
		
	# connect initializer to finish signal
	connect(phrase_completed_signal_name, signal_reciever, signal_reciever_method)

func reset_prompt_buttons():
	# Timer.start() should be good enough since the timer shouldn't tick while
	# this method is ticking
	# BUT
	$Timer.stop()
	current_word_in_phrase = 0
	$Timer.start()

func generate_word_column(column_number : int, correct_word : String, num_buttons : int) -> Control:
	# Step 0: Create the VBox Container
	var new_box = word_box_scene.instance()
	new_box.init_pwvbox(self, vBox_signal_reciever, column_number, correct_word, num_buttons)
	
	return new_box
	
func handle_correct_column():
	# increase which word in the phrase we care about
	current_word_in_phrase += 1
	
	# if we're out of words in the phrase, pass the phrase
	if(current_word_in_phrase >= phrase_length):
		pass_phrase()
	
func begin_phrase():
	self.show()
	$Timer.start()
	
func fail_phrase():
	$Timer.stop()
	emit_signal(phrase_completed_signal_name, false)
	
func pass_phrase():
	$Timer.stop()
	emit_signal(phrase_completed_signal_name, true)

func on_PromptWordVBoxContainer_ColumnComplete(completed_successfully : bool, col_num : int):
	if(col_num == current_word_in_phrase && completed_successfully):
		handle_correct_column()
	else:
		fail_phrase()

func _on_Timer_timeout():
	fail_phrase()
