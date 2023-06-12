extends Control

export(NodePath) var active_app_control_nodepath
export(NodePath) var inactive_app_control_nodepath
var active_app_control
var inactive_app_control

# This is that dict
export var appslate_path_dict = {}
export(GameEnums.GameStoryBeat) var starting_appslate_type = GameEnums.GameStoryBeat.DEBUG
var appslate_dict = {}
var current_appslate

signal BackButtonPressed()
var back_button_signal_name = "BackButtonPressed"
signal HomeButtonPressed()
var home_button_signal_name = "HomeButtonPressed"
signal OptsButtonPressed()
var opts_button_signal_name = "OptsButtonPressed"

signal StoryBeatTriggered(story_beat)
var story_beat_signal_name = "StoryBeatTriggered"

var appslate_handler_name = "_on_appslate_change_requested"
var notification_handler_name = "_on_phone_notification_triggered"
var storybeat_handler_name = "_on_game_story_beat_triggered"

func _ready():
	active_app_control = get_node(active_app_control_nodepath)
	inactive_app_control = get_node(inactive_app_control_nodepath)
	
	initialize_appslates()
	
func initialize_appslates():
	# First:
	var new_app
	for key in appslate_path_dict.keys():
		#Step 0: Turn the appslate path into the actual appslate
		appslate_dict[key] = get_node(appslate_path_dict[key])
		
		#Step 2: set its my_appslate_type to the key of its dict entry
		
		appslate_dict[key].my_appslate_type = key
		#Step 4: connect all its signals
		connect_mandatory_signals(appslate_dict[key])
	
	# Second: Do the logic from change_active_appslate, but skip the
	# steps regarding the old current
	var starting_appslate = appslate_dict[starting_appslate_type]
	connect_appslate_signals(starting_appslate, false)
	inactive_app_control.remove_child(starting_appslate)
	active_app_control.add_child(starting_appslate)
	starting_appslate.rect_position = Vector2.ZERO
	current_appslate = starting_appslate

func change_active_appslate(new_appslate : Node):
	if(new_appslate == current_appslate):
		return
	
	var old_appslate = current_appslate
	
	disconnect_appslate_signals(old_appslate, false)
	connect_appslate_signals(new_appslate, false)
	
	inactive_app_control.remove_child(new_appslate)
	active_app_control.remove_child(old_appslate)
	
	# parent old to inactive
	inactive_app_control.add_child(old_appslate)
	# parent new to active
	active_app_control.add_child(new_appslate)
	
	# center new_appslate on its parent
	# If I understand it correctly, rect_position (0, 0) places the appslate's
	# top-left corner at the top-left corner of the parent. So as long as
	# that corner is in the top-left corner of the frame, setting rect_position
	# to 0, 0 will center the appslate
	new_appslate.rect_position = Vector2.ZERO
	
	current_appslate = new_appslate
	
func change_active_appslate_by_type(new_appslate_type):
	# new_appslate_type : GameEnums.AppSlateType
	change_active_appslate(appslate_dict[new_appslate_type])

func connect_appslate_signals(appslate : Node, connect_beat_and_notif : bool):
	# Connect appslate's button signals
	connect(back_button_signal_name, appslate, appslate.back_button_handler_name)
	connect(home_button_signal_name, appslate, appslate.home_button_handler_name)
	connect(opts_button_signal_name, appslate, appslate.opts_button_handler_name)
	
	# Connect appslate's change appslate signals
	appslate.connect(appslate.slate_change_signal_name, self, appslate_handler_name)
	
	# If connecting a signal that is already connected doesn't error, then this isn't necessary
	# BUT
	if(connect_beat_and_notif):
		connect_mandatory_signals(appslate)
	
func disconnect_appslate_signals(appslate, disconnect_beat_and_notif : bool):
	# Disconnect appslate's button signals
	disconnect(back_button_signal_name, appslate, appslate.back_button_handler_name)
	disconnect(home_button_signal_name, appslate, appslate.home_button_handler_name)
	disconnect(opts_button_signal_name, appslate, appslate.opts_button_handler_name)
	
	# Disconnect appslate's change appslate signals
	appslate.disconnect(appslate.slate_change_signal_name, self, appslate_handler_name)
	
	# FOR RIGHT NOW, inactive appslates should still send notifications and story beats
	# But if we don't want that to happen...
	if(disconnect_beat_and_notif):
		disconnect_mandatory_signals(appslate)
	
	#sender.(signal, reciever_object, reciever_method)

func connect_mandatory_signals(appslate):
	appslate.connect(appslate.notification_signal_name, self, notification_handler_name)
	appslate.connect(appslate.story_beat_signal_name, self, storybeat_handler_name)
	
func disconnect_mandatory_signals(appslate):
	appslate.disconnect(appslate.notification_signal_name, self, notification_handler_name)
	appslate.disconnect(appslate.story_beat_signal_name, self, storybeat_handler_name)

# --- SIGNAL HANDLERS ---

# appslate_type : GameEnums.AppSlateType
func _on_appslate_change_requested(appslate_type):
	change_active_appslate_by_type(appslate_type)

# appslate_type : GameEnums.AppSlateType
func _on_phone_notification_triggered(appslate_type, notif : String):
	print("Notification from Appslate Type " + str(appslate_type) + ": " + notif)
	pass
	
# story_beat : GameEnums.GameStoryBeat
func _on_game_story_beat_triggered(story_beat):
	print("GameStoryBeat " + str(story_beat) + " triggered")
	emit_signal(story_beat_signal_name, story_beat)

func _on_BackButton_pressed():
	emit_signal(back_button_signal_name)

func _on_HomeButton_pressed():
	emit_signal(home_button_signal_name)

func _on_OptsButton_pressed():
	emit_signal(opts_button_signal_name)
