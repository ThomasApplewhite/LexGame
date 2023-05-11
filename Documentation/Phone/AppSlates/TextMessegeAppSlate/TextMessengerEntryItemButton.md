# TextMessengerEntryItemButton
extends Button

TextMessengerEntryItemButton is a UI button that emulates a text messenger's conversation selection button. Each ConversationEntryNode will have a button generated for it, and selecting that button will bring up the corresponding ConversationEntryNode's ConversationAppSlate.

btw, _fields_ and _child nodes_ are _italics_, while **functions** and **signals** are **bold**.

### Fields
onready initials_text: Holds a reference to InitialColorRect/InitialRichTextLabel.

onready message_text: Holds a reference to MessageColorRect/MessageRichTextLabel.

### Child Nodes
BackgroundColorRect: Visual Background for the button

InitialColorRect: Visual Background for the Initials Text

InitialColorRect/InitialRichTextLabel: RTL that will hold 1 or 2 letters representing the person who is talking in the conversation represented by the button.

MessageColorRect: Visual Background for the Message Text

MessageColorRect/MessageRichTextLabel: RTL that will hold the beginning of the text in the current part of the conversation. It is intended that this node will automatically crop text that is too long, so there's no concern for just dumping the whole text in there.

## func set_initials_text(new_initials_text : String):
Sets _initials_text.bbcode_text_ to _new_initials_text_. Made an entire method to make setting text fields easy for other nodes (specifically TextMessengerAppSlate)

## func set_message_text(new_message_text : String):
Sets _message_text.bbcode_text_ to _new_message_text_. Made an entire method to make setting text fields easy for other nodes (specifically TextMessengerAppSlate)
