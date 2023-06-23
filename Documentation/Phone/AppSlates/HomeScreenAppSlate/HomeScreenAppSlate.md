# HomeScreenAppSlate
extends AppSlate

HomeScreenAppSlate is the default AppSlate that leads back to all the others. It is the phone's default state. There's no functionality on the HomeScreen, other than buttons that lead back to other AppSlates.

Doesn't do much for right now, mostly a stub. Because types of AppSlates won't be dynamically added to the game, HomeScreenAppSlate will use child buttons and auto-generated signal receiver methods to move to each AppSlate.

btw, _fields_ and _child nodes_ are _italics_, while **functions** and **signals** are **bold**.

### Fields
_None lmao._

### Child Nodes
Child Node Name: purpose
DebugBorderColorRect: Debug color rect to show size of the AppSlate

GridContainer: Organizer for various HomeScreen buttons

GridContainer/TextMessengerButton: Button whose **pressed** signal is connected to **_on_TextMessengerButton_pressed()**

## func _on_TextMessengerButton_pressed():
Connected to _TextMessengerButton_. Emits the _AppSlate.slate_change_signal_name_ with the GameEnums.AppSlateType.TEXT AppSlate.
	
## func _on_back_button_pressed():
Override from AppSlate. 

No functionality. This is intentional.
	
## func _on_home_button_pressed():
Override from AppSlate. 

No functionality. This is intentional.
	
## func _on_opts_button_pressed():
Override from AppSlate. 

No functionality. This is intentional.

