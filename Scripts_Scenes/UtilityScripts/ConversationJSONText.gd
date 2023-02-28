class_name ConversationJSONText extends Resource

export(String, MULTILINE) var json_text

func _init():
	pass

func get_text() -> String:
	return json_text

func is_type(type): 
	return type == get_type()

func get_type(): 
	return "ConversationJSONText"
