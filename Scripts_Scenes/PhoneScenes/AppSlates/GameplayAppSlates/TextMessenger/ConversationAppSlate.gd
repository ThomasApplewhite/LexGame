extends AppSlate

var prompt_control_scene = preload("res://Scripts_Scenes/PromptScenes/PromptControl/PromptControl.tscn")
var convo_type = preload("res://Scripts_Scenes/PhoneScenes/ConversationParsing/ConversationParser.gd")

var prompt_completed_receiver_name = "_on_PromptControl_completed"

var convoJSON_resource : Resource
var convo_parser #ConversationParser
var entry_parent : Node

var next_convo_dict : Dictionary
var active_prompt_control #PromptControl
var starting_convo_index : int

"""
In addition to all the stuff that the Tester does:
- Have an export slot for a conversation resource
	!!!NO!!! This is for the conversation entry to dealth
- Format/organize text messages and prompts
- actually do data parsing
- Setup timers and wait for appropriate story beats
- Send notification messages
- Create PromptControls
- Intercept Prompt Completed signals

The ConvoSlate also needs to:
- Ask the text slate to make it the active appslate
- Have some way of attaching timers for notifs to the ConvoSlate (remember ConvoSlates are _not_ intended to persist in the background
- Receiving story beats from the phone
- _Somehow_ persist the state of the conversation between instances of the same conversation. Somehow...
- Delay text activation until story beats are recieved

On that idea of persisting data and timers: what if conversation slate had a special 'parent' node that held its data and timers: a part that _did_ persist. It wouldn't carry all of the data, though. It could hold:
- timers
- conversation messages already sent (or, at least, their indices)
- conversation data paths
- _maybe_ cached parser data. It's be a lot to hold onto... Maybe...
	* No, reparse every time. A load on a text message click is realistic.
- The text of the previous message. To show as a preview on the phone, maybe.

Other things that should happen based on other notes:
recieve init data from conversation entry
send init data back to conversation entry when asked

"""


# should save new convo resource and probably also starting index for parse-ahead
func _init(new_convoJSON_resource : Resource, new_entry_node : Node, new_starting_index : int = 0):
	convoJSON_resource = new_convoJSON_resource
	entry_node = new_entry_node
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
	next_convo_dict = convo_dict
	
	# Setup timer and activate it
	put timer setup method here
	# $FirstPushTimer.set_wait_time(next_convo_dict[convo_type.JSONFields.FIRSTPUSHTIME])
	# print(next_convo_dict[convo_type.JSONFields.FIRSTPUSHTIME])
	# $FirstPushTimer.start()

func pop_process_convo_dict():
	process_convo_dict(convo_parser.get_next_conversation_chunck())

func display_pregenerated_data():
	PARTNER FORMATTING GOES HERE
	
	FAST-FORWARDING THE CONVERSATION SHOULD ALSO GO HERE

func display_next_convo_dict():
	create_static_message_text()
	pop_process_convo_dict()
	
func create_static_message_text():
	I think this is essentially how this should go but it needs some edits to match scene structure
	
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
	active_prompt_control.init_prompt_control(self, prompt_completed_receiver_name, new_prompt_settings)

	# also start repush timer
	REPUSH TIMER METHOD HERE
	$RepushTimer.set_wait_time(prompt_content[convo_type.JSONFields.REPUSHTIME])
	$RepushTimer.start()
	
func send_first_timer_to_entry_node():
	WE NEED TO SEND ONESHOT NOTIF HERE
	pass
	
func send_repush_timer_to_entry_node():
	WE NEED TO SEND REPUSH TIMERS HERE
	pass
	
func stop_timer_on_entry_node():
	WE NEED TO DISABLE TIMERS THAT ARE ON THE CONVERSATION ENTRY TOO
	pass

func handle_next_convo_dict_sent():
	THIS METHOD NEEDS TO HANDLE STORY BEATS TOO NOW
	# is there a prompt?
	if(next_convo_dict[convo_type.JSONFields.CONTAINSPROMPT]):
		create_lex_prompt()
		return
	else:
		display_next_convo_dict()
	
ALL OF THESE HANDLERS NEED ADJUSTMENT

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
	
	NEED A WAY TO SAVE AND TRACK TEXTS ALREADY SENT
