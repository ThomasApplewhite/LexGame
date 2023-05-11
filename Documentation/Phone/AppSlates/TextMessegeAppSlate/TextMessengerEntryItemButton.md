# TextMessengerEntryItemButton
extends Button

TextMessengerEntryItemButton is a UI button that emulates a text messenger's conversation selection button. Each ConversationEntryNode will have a button generated for it, and selecting that button will bring up the corresponding ConversationEntryNode's ConversationAppSlate.

The button's base "pressed" signal is connected to TextMessengerEntrytItemButton's script in-editor.

btw, _fields_ and _child nodes_ are _italics_, while **functions** and **signals** are **bold**.

### Fields
onready initials_text: Holds a reference to InitialColorRect/InitialRichTextLabel.

onready message_text: Holds a reference to MessageColorRect/MessageRichTextLabel.

entry_button_signal_name: Holds the name of the EntryButtonPressed signal

convo_entry_node: Holds a reference to the ConversationEntryNode associated with this button.

### Child Nodes
BackgroundColorRect: Visual Background for the button

InitialColorRect: Visual Background for the Initials Text

InitialColorRect/InitialRichTextLabel: RTL that will hold 1 or 2 letters representing the person who is talking in the conversation represented by the button.

MessageColorRect: Visual Background for the Message Text

MessageColorRect/MessageRichTextLabel: RTL that will hold the beginning of the text in the current part of the conversation. It is intended that this node will automatically crop text that is too long, so there's no concern for just dumping the whole text in there.

## signal EntryButtonPressed(self_button, associated_convo_entry):
Emitted whenever the normal Button signal is recieved. This signal is essentially identical to the normal 'pressed' signal, it just contains more information.

## func set_initials_text(new_initials_text : String):
Sets _initials_text.bbcode_text_ to _new_initials_text_. Made an entire method to make setting text fields easy for other nodes (specifically TextMessengerAppSlate)

## func set_message_text(new_message_text : String):
Sets _message_text.bbcode_text_ to _new_message_text_. Made an entire method to make setting text fields easy for other nodes (specifically TextMessengerAppSlate)

## func set_convo_entry_node(new_node : Node):
Setter for _convo_entry_node_. Sets _convo_entry_node_ to _new_node_.

## func get_pressed_signal_name() -> String:
Getter for _entry_button_signal_name_. Returns _entry_button_signal_name_.

## func _on_TextMessengerEntryItemButton_pressed():
Reciever for the base "pressed" signal is emitted. Emits the signal in _entry_button_signal_name_, with self as the button and _convo_entry_node_ as the associated convo entry.

