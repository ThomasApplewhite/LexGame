# PromptPhrase
extends Reference

PromptPhrases represent one stage of a Prompt gameplay element: The phrase Lex needs to complete, how many false words per column there are, and how long he has to do it.

PromptSettings is a class_name'd type. It can't be instanced as a node.

### Fields
finished_phrase : an array of strings representing the phrase Lex needs to type out. Each item in the array is one word.

rows : the number of buttons should be in each column when this phrase is played. Since one button will be the 'correct' button, rows - 1 is the amount of fail buttons per column.

phrase_time : the time, in seconds, Lex has to complete the phrase before the phrase automatically fails.
	
## func _init(new_rows : int, new_phrase_time : int, new_finished_phrase):
Constructor. new_finished_phrase is an array of strings.
	
finished_phrase = new_finished_phrase
rows = new_rows
phrase_time = new_phrase_time

Legit that's it.
