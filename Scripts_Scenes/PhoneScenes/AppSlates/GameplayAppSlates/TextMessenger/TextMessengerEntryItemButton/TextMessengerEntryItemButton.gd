extends Button

onready var initials_text = $InitialColorRect/InitialRichTextLabel
onready var message_text = $MessageColorRect/MessageRichTextLabel

func set_initials_text(new_initials_text : String):
	initials_text.bbcode_text = new_initials_text

func set_message_text(new_message_text : String):
	message_text.bbcode_text = new_message_text
