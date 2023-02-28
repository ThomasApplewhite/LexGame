extends VBoxContainer


var button_signal = "PromptWordPressed"
var button_signal_reciever = "_on_PromptWordButton_pressed"

var button_scene = preload("res://Scripts_Scenes/PromptScenes/PromptWordButton/PromptWordButton.tscn")
var correct_button_num : int

signal ColumnComplete(completed_successfully, column_number)
var column_complete_signal = "ColumnComplete"

var column_number

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init_pwvbox(parent_controller, parent_callback : String, assigned_number : int, correct_word : String, num_buttons : int):
		
	# Step -1: Label Column
	column_number = assigned_number
	
	# Step 0: Pick which button will hold the right answer
	correct_button_num = randi() % num_buttons
	
	# for each button
	var new_button
	var new_button_word
	for button_num in num_buttons:
		# Step 1: Generate button
		new_button = button_scene.instance()
		new_button.word_number = button_num
		
		# if this button is to hold the right word, put in the word
		# otherwise, generate a word
		if(button_num == correct_button_num):
			new_button_word = correct_word
		else:
			new_button_word = "TBD"
		new_button.set_label_word(new_button_word)
	
		# Step 2: Wire button to VBox response method
		new_button.connect(button_signal, self, button_signal_reciever)
		
		# Step 3: parent button to the box
		add_child(new_button)
		
	# Step 1: connect parent to the container's column complete signal
	connect(column_complete_signal, parent_controller, parent_callback)

func _on_PromptWordButton_pressed(button_number : int):
	emit_signal(column_complete_signal, button_number == correct_button_num, column_number)
