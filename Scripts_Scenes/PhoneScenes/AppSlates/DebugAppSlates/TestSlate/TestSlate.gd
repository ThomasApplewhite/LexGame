extends AppSlate
# That's a weird way to do the extention, lol.
# Wouldn't it just be extends AppSlate?
# Or does that require a class_name?
# idk, it doesn't matter

export var label_name = "BLANK"

# This is a GameEnums.AppSlateType, but only native/built-in types can be exported
export var appslate_type_to_change_to = 0

func _ready():
	$Label.text = "I am Slate " + label_name

# Implement all of these with a simple print statement
# ---Phone Button Signal Receivers---
func _on_back_button_pressed():
	print("The back button was pressed!")
	
func _on_home_button_pressed():
	print("The home button was pressed!")
	
func _on_opts_button_pressed():
	print("The Options button was pressed!")
	
# ---AppSlate Button Signal Recievers---

func _on_PushButton_pressed():
	emit_signal(_get_notification_signal_name(), _get_my_appslate_type(), "Debug Notif!")


func _on_ChangeButton_pressed():
	emit_signal(_get_slate_change_signal_name(), appslate_type_to_change_to)
	

func _on_StoryBeatButton_pressed():
	emit_signal(_get_story_beat_signal_name(), GameEnums.GameStoryBeat.DEBUG)
	pass


func _on_SlateTypeButton_pressed():
	# remember this is gonna come out as a number, not an enum
	# If I need it to come out as a string I suppose I can add a utility method
	# to GameEnums.
	print("My SlateType is " + str(_get_my_appslate_type()))
