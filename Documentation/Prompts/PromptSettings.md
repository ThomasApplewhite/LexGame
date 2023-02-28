# PromptSettings
extends Reference

PromptSettings is essentially a struct that holds an array of PromptPhrases and the non-interactive text that gets displayed above gameplay elements.

PromptSettings is a class_name'd type. It can't be instanced as a node.

### Fields
phrases : holds an array of PromptPhrases that make up the interactive elements of the Prompt

prompt_text : the non-interactive text of the prompt

## func _init(new_prompt_text : String, new_phrases):
Constructor, I think. Sets _prompt_text_ to be _new_prompt_text_ and _phrases_ to be _new_phrases_

Oh, and the reason new_phrases isn't statically typed is because you can't static type array args in Godot, I don't think.
	
## func get_num_phrases() -> int:
Returns **len(phrases)**
