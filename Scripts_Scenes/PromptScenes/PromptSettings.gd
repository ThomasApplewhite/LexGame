class_name PromptSettings extends Reference

# other initialization stuff will go here as I need it
# For values that I don't know how to type in Godot, I've added a comment instead
var phrases #Array<PromptPhrase>
var prompt_text : String
	
func _init(new_prompt_text : String, new_phrases):
	prompt_text = new_prompt_text
	phrases = new_phrases
	
func get_num_phrases() -> int:
	return len(phrases)
