extends AppSlate

var prompt_control_scene = preload("res://Scripts_Scenes/PromptScenes/PromptControl/PromptControl.tscn")
var convo_type = preload("res://Scripts_Scenes/PhoneScenes/ConversationParsing/ConversationParser.gd")

var prompt_completed_receiver_name = "_on_PromptControl_completed"

var convoJSON_resource : Resource
var convo_parser #ConversationParser
var entry_parent : Node

var active_convo_dict : Dictionary
var active_convo_index : int
var active_prompt_control #PromptControl
var starting_convo_index : int

# should save new convo resource and probably also starting index for parse-ahead
func initialize_convo_slate(new_convoJSON_resource : Resource, new_entry_node : Node, new_starting_index : int = 0):
	convoJSON_resource = new_convoJSON_resource
	entry_parent = new_entry_node
	starting_convo_index = new_starting_index
	
# Called when the node enters the scene tree for the first time.
func _ready():
	# do we want to put start_convo_slate here?
	pass
	
func start_convo_slate():
	# Step -1: Make sure we have the right kind of resource:
	if !convoJSON_resource.is_type("ConversationJSONText"):
		push_error("Wrong resource type lol!")
		return
		
	# Step 0: Init the conversation parser
	convo_parser = convo_type.new(convoJSON_resource)
	
	# Step 1: Parse the JSON into the conversation chunks
	convo_parser.parse_json_file()
	
	# Step 2: Setup conversation partner/header data
	display_pregenerated_data()

	# Step 3: Start popping and parsing convo pieces!
	pop_process_convo_dict()

func process_convo_dict(convo_dict):
	# do we have a chunk to even send?
	if(convo_dict[convo_type.JSONFields.TRIGGERSTORYBEAT] == GameEnums.GameStoryBeat.EOF):
		print("We're out of conversations!")
		return
	
	# Save out the incoming dict as the next piece of the game to print out
	active_convo_dict = convo_dict
	active_convo_index = convo_type.JSONFields.CONVERSATIONINDEX
	
	# Setup timer and activate it
	send_first_timer_to_entry_node()

func end_convo_slate() -> int:
	# any other breakdown we need, do it now
	return active_convo_index

func pop_process_convo_dict():
	process_convo_dict(convo_parser.get_next_conversation_chunck())

func display_pregenerated_data():
	# for right now, just update the Mock Partner Label
	$HeaderControl/MockPartnerLabel.text = convo_parser.conversation_partner
	
	# Fast-forward the conversation to the current index
	for convo_dict in convo_parser.get_conversation_subarray(starting_convo_index):
		create_static_message_text(convo_dict)

func display_next_convo_dict():
	create_static_message_text(active_convo_dict)
	pop_process_convo_dict()
	
func create_static_message_text(convo_dict):
	# This probably needs additional formatting, but I'll get that later
	var partner_message = RichTextLabel.new()
	partner_message.bbcode_enabled = true
	partner_message.bbcode_text = convo_dict[convo_type.JSONFields.PARTNERMESSAGETEXT]
	$TextControl/ScrollContainer/VBoxContainer.add_child(partner_message)
	
	if(convo_dict[convo_type.JSONFields.CONTAINSPROMPT]):
		var lex_message = RichTextLabel.new()
		var lex_text = convo_dict[convo_type.JSONFields.PROMPTCONTENTS][convo_type.JSONFields.LEXMESSAGETEXT]
		lex_text = "[right]" + lex_text + "[/right]"
		lex_message.bbcode_enabled = true
		lex_message.bbcode_text = lex_text
		$TextControl/ScrollContainer/VBoxContainer.add_child(lex_message)

func create_lex_prompt():
	# create and init prompt settings
	var prompt_content = active_convo_dict[convo_type.JSONFields.PROMPTCONTENTS]
	var new_prompt_settings = prompt_content[convo_type.JSONFields.PROMPTSETTINGS]
	active_prompt_control = prompt_control_scene.instance()
	$TextControl/PromptControl.add_child(active_prompt_control)
	active_prompt_control.init_prompt_control(self, prompt_completed_receiver_name, new_prompt_settings)

	# also start repush timer
	send_repush_timer_to_entry_node()

	
func send_first_timer_to_entry_node():
	# Timers should really be the responsibility of the conversation entry
	entry_parent.create_first_push_timer(active_convo_index, active_convo_dict[convo_type.JSONFields.FIRSTPUSHTIME])

	# $FirstPushTimer.set_wait_time(next_convo_dict[convo_type.JSONFields.FIRSTPUSHTIME])
	# print(active_convo_dict[convo_type.JSONFields.FIRSTPUSHTIME])
	# $FirstPushTimer.start()
	
	
func send_repush_timer_to_entry_node():
	# Timers should really be the responsibility of the conversation entry
	entry_parent.create_repush_push_timer(active_convo_index, active_convo_dict[convo_type.JSONFields.REPUSHTIME])
	
	# $RepushTimer.set_wait_time(prompt_content[convo_type.JSONFields.REPUSHTIME])
	# $RepushTimer.start()
	
func stop_timer_on_entry_node():
	entry_parent.cancel_repush_timer(active_convo_index)

func handle_next_convo_dict() -> String:
	# convo entry should handle determining when we should get the next
	# convo dict
	# I should probably document the difference between convo_dict and next_convo_dict
	
	# is there a prompt?
	if(active_convo_dict[convo_type.JSONFields.CONTAINSPROMPT]):
		create_lex_prompt()
	else:
		display_next_convo_dict()
		
	return active_convo_dict[convo_type.JSONFields.PARTNERMESSAGETEXT]

func handle_prompt_completed():
	# Stop the repush timer
	stop_timer_on_entry_node()
	
	# free the lex prompt
	if(active_prompt_control):
		active_prompt_control.queue_free()
		
	# Print out the last of the message text
	display_next_convo_dict()
