extends Button

onready var initials_text = $InitialColorRect/InitialRichTextLabel
onready var message_text = $MessageColorRect/MessageRichTextLabel

signal EntryButtonPressed(self_button, associated_convo_entry)
var entry_button_signal_name = "EntryButtonPressed"

var convo_entry_node : Node

func set_initials_text(new_initials_text : String):
	initials_text.bbcode_text = new_initials_text

func set_message_text(new_message_text : String):
	message_text.bbcode_text = new_message_text
	
func set_convo_entry_node(new_node : Node):
	convo_entry_node = new_node

func get_pressed_signal_name() -> String:
	return entry_button_signal_name

func _on_TextMessengerEntryItemButton_pressed():
	emit_signal(entry_button_signal_name, self, convo_entry_node)
