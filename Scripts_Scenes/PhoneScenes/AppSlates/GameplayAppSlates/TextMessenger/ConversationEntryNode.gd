extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
"""
What the conversation entry needs to do
ALL TIMER RELATED NONSENSE
AND STORYBEAT NONSENSE
SHOULD BE HANDLED BY YHE CONVERSATION ENTRY
BASICALLY ANY WORK THAT ISNT FORMATTING PARSER OUTPUT
NOTIFICATIONS? TIMERS? CONVO ENTRY! THEY SHOULD RESET WHEN THE CONVO SLATE OPEN AND ONLY
SEND  NOTIFS IF THE SALTE IS OPEN. THAT IS TO SAY, THEIR HANDLERS NEED SOME BRANCHING
- Setup timers and wait for appropriate story beats
- Send notification messages
- Ask the text slate to make it the active appslate
- Have some way of attaching timers for notifs to the ConvoSlate (remember ConvoSlates are _not_ intended to persist in the background
- Receiving story beats from the phone
- _Somehow_ persist the state of the conversation between instances of the same conversation. Somehow...
- Delay text activation until story beats are recieved
- The text of the previous message. To show as a preview on the phone, maybe.
"""
