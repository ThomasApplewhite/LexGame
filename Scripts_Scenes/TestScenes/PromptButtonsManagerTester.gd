extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var test_prompt : PromptSettings
var prompt_control_scene = preload("res://Scripts_Scenes/PromptScenes/PromptControl/PromptControl.tscn")
var prompt_buttons_scene = preload("res://Scripts_Scenes/PromptScenes/PromptButtonsManager/PromptButtonsManager.tscn")
var prompt_vbox_scene = preload("res://Scripts_Scenes/PromptScenes/PromptWordVBoxContainer/PromptWordVBoxContainer.tscn")
var prompt



var test_pman

var test_vbox_not_man = false


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	#create_test_manager()
	create_test_prompt_control()
	
	return
	
	if(test_vbox_not_man):
		create_test_vbox()
	else:
		create_test_manager()
	
func create_test_vbox():
	# wait no let's just use a phrase
	var tp_length = 3
	var tp_rows = 5
	var tp_time = 10
	var test_phrase = create_test_phrase(tp_length, tp_rows, tp_time)
	
	var test_vbox = prompt_vbox_scene.instance()
	var tvbox_id = 0
	var tvbox_signal = "_on_column_event"
	var tvbox_correct_word = test_phrase.get_word_at_index(0)
	test_vbox.init_pwvbox(self, tvbox_signal, tvbox_id, tvbox_correct_word, test_phrase.rows)
	add_child(test_vbox)
	print("vbox attached")
	print(test_phrase.finished_phrase)
	
func _on_column_event(completed_successfully, column_number):
	if completed_successfully:
		print("Correct Button!")
	else:
		print("Incorrect Button!")
		
func create_test_manager():
	# wait no let's just use a phrase
	var tp_length = 3
	var tp_rows = 5
	var tp_time = 10
	var test_phrase = create_test_phrase(tp_length, tp_rows, tp_time)
	
	test_pman = prompt_buttons_scene.instance()
	test_pman.init_prompt_buttons(self, "_on_manager_event", test_phrase)
	add_child(test_pman)
	
	test_pman.begin_phrase()
	print("buttons manager attached")
	print(test_phrase.finished_phrase)
	
func create_test_prompt_control():
	var test_prc = prompt_control_scene.instance()
	add_child(test_prc)
	test_prc.init_prompt_control(self, "_on_manager_event", create_test_prompt())
	
	print("prompt controll attached")
	
	
func _on_manager_event():
	print("Prompt completed!")
	

func create_test_prompt() -> PromptSettings:
	# I think normally these would come from sone sort of config file
	# but for NOW, just make one, I guess
	# A prompt settings is of text and a phrase string so lets just....
	
	# I'm gonna make an actual prompt for this one
	# func _init(new_rows : int, new_phrase_time : int, new_finished_phrase):
	var manual_phrases = [
		PromptPhrase.new(3, 10, ["Each", "phrase", "is"]),
		PromptPhrase.new(3, 10, ["a", "collection", "of",]),
		PromptPhrase.new(5, 5, ["short", "easy", "button", "labels"])
	]
	var manual_text = "This is static text"
	return PromptSettings.new(manual_text, manual_phrases)
	
	
	# wait does this work?
	var phrases = []
	var phrase_array = []
	var new_phrase

	for i in 2:
		new_phrase = create_test_phrase(i + 2, i + 2, 5)
		phrases.append(new_phrase)
		
	return PromptSettings.new("This is some prompt text", phrases)

func create_test_phrase(phrase_length : int, phrase_rows : int, phrase_time : float) -> PromptPhrase:
	var phrase_array = []
	
	for x in phrase_length:
		phrase_array.append("WORDS")
		
	return PromptPhrase.new(phrase_rows, phrase_time, phrase_array)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
