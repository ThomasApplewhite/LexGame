extends AppSlate

onready var entry = $ConversationEntryNode

func toggle_convo_entry(toggle : bool):
	if(toggle && !entry._get_convo_slate_is_active()):
		entry.create_conversation_slate()
		return
		
	if(!toggle && entry._get_convo_slate_is_active()):
		entry.remove_conversation_slate()

func _on_OnButton_pressed():
	toggle_convo_entry(true)


func _on_OffButton_pressed():
	toggle_convo_entry(false)
