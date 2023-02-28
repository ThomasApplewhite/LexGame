extends Button

# Word numbr identifies which word this button is in a column
var word_number : int

signal PromptWordPressed(word_number)

func set_label_word(word):
	# Formatting goes here
	$RichTextLabel.text = word

func _on_PromptWordButton_pressed():
	emit_signal("PromptWordPressed", word_number)

