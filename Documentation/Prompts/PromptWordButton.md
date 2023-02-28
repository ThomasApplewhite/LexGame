# PromptWordButton
extends Button

It's a button. Legit, that's it. We're really here for the _RichTextLabel_ and the extra data on the pressed signal.

### Fields
word_number: ID Number that represents which button in a PromptWordVBoxContainer it is

### Child Nodes
RichTextLabel: Holds the text of the PromptWordButton

## signal PromptWordPressed(word_number)
Wrapper for Button's **pressed()** signal, but that also sends the word number.

## func set_label_word(word):
Will handle formatting the button, but for right now just sets the text on the _RichTextLabel_.
Probably needs to include something to tell the button it's the right
button so that way it can, like, look right

## func _on_PromptWordButton_pressed():
emit_signal("PromptWordPressed", word_number)
Literally that's it, that's the tweet.

