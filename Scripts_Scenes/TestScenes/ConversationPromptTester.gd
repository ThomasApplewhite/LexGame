extends Control

export var conversation_resource : Resource
var prompt_control_scene = preload("res://Scripts_Scenes/PromptScenes/PromptControl/PromptControl.tscn")
var convo_type = preload("res://Scripts_Scenes/PhoneScenes/ConversationParsing/ConversationParser.gd")

var convo_parser

var next_convo_dict
var active_prompt_control

# Called when the node enters the scene tree for the first time.
func _ready():
	test_prompt_with_conversation()
	
func test_prompt_with_conversation():
	# Step -1: Make sure we have the right kind of resource:
	if !conversation_resource.is_type("ConversationJSONText"):
		push_error("Wrong resource type lol!")
		return
	
	# Step 0: Init the conversation parser
	convo_parser = convo_type.new(conversation_resource)
	
	# Step 1: Parse the JSON into the conversation chunks
	convo_parser.parse_json_file()
	
	# Step 2: Setup conversation partner/header data
	$PartnerLabel.text = convo_parser.conversation_partner
	
	# Step 3: Start popping and parsing convo pieces!
	pop_process_convo_dict()
	
func process_convo_dict(convo_dict):
	# do we have a chunk to even send?
	if(convo_dict[convo_type.JSONFields.TRIGGERSTORYBEAT] == GameEnums.GameStoryBeat.EOF):
		print("We're out of conversations!")
		return
	
	# Save out the incoming dict as the next piece of the game to print out
	next_convo_dict = convo_dict
	
	# Setup timer and activate it
	$FirstPushTimer.set_wait_time(next_convo_dict[convo_type.JSONFields.FIRSTPUSHTIME])
	print(next_convo_dict[convo_type.JSONFields.FIRSTPUSHTIME])
	$FirstPushTimer.start()

func pop_process_convo_dict():
	process_convo_dict(convo_parser.get_next_conversation_chunck())

func display_next_convo_dict():
	create_static_message_text()
	pop_process_convo_dict()
	
func create_static_message_text():
	var partner_message = Label.new()
	partner_message.text = next_convo_dict[convo_type.JSONFields.PARTNERMESSAGETEXT]
	$ConversationDisplayControl/VBoxContainer.add_child(partner_message)
	
	if(next_convo_dict[convo_type.JSONFields.CONTAINSPROMPT]):
		# can I singleline this?
		# $ConversationDisplayControl/VBoxContainer.add_child(Label.new().set_text(next_convo_dict[convo_type.JSONFields.PROMPTCONTENTS][convo_type.JSONFields.LEXMESSAGETEXT]))
		# lol this sucks
		var lex_message = Label.new()
		lex_message.set_text("Lex: " + next_convo_dict[convo_type.JSONFields.PROMPTCONTENTS][convo_type.JSONFields.LEXMESSAGETEXT])
		$ConversationDisplayControl/VBoxContainer.add_child(lex_message)

func create_lex_prompt():
	# create and init prompt settings
	var prompt_content = next_convo_dict[convo_type.JSONFields.PROMPTCONTENTS]
	var new_prompt_settings = prompt_content[convo_type.JSONFields.PROMPTSETTINGS]
	active_prompt_control = prompt_control_scene.instance()
	$ConversationDisplayControl/PromptAnchorControl.add_child(active_prompt_control)
	active_prompt_control.init_prompt_control(self, "_on_PromptControl_completed", new_prompt_settings)

	# also start repush timer
	$RepushTimer.set_wait_time(prompt_content[convo_type.JSONFields.REPUSHTIME])
	$RepushTimer.start()

func handle_next_convo_dict_sent():
	# is there a prompt?
	if(next_convo_dict[convo_type.JSONFields.CONTAINSPROMPT]):
		create_lex_prompt()
		return
	else:
		display_next_convo_dict()
	

func handle_prompt_completed():
	# Stop the repush timer
	$RepushTimer.stop()
	
	# free the lex prompt
	if(active_prompt_control):
		active_prompt_control.queue_free()
		
	# Print out the last of the message text
	display_next_convo_dict()

func _on_FirstPushTimer_timeout():
	handle_next_convo_dict_sent()


func _on_RepushTimer_timeout():
	# This would normally send the repush notif, but I'm just gonna
	# send a notification
	print("Repush notification!")
	
	
func _on_PromptControl_completed():
	handle_prompt_completed()
