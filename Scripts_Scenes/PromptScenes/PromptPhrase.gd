class_name PromptPhrase extends Reference

var finished_phrase #Array<String>
var rows : int
var phrase_time : float
	
func _init(new_rows : int, new_phrase_time : int, new_finished_phrase):
	finished_phrase = new_finished_phrase
	rows = new_rows
	phrase_time = new_phrase_time

func get_word_at_index(index : int) -> String:
	return finished_phrase[index]
