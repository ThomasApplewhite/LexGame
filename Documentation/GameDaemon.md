# GameDaemon
extends Node

Also known as GameDaemonNode, the GameDaemon can be understood as a Game/LevelManager. The GameDaemon implements the progression of the game by expecting and reacting to certain GameStoryBeats in order. How it does this hasn't been implemented yet, but it will probably be a simple list of GameStoryBeats to iterate through in order.

The GameDaemon's primary purpose is to receive GameStoryBeat signals from the PhoneControl to decide if the game should progress. In addition to any other consequences of a GameStoryBeat (which I haven't decided on yet), the GameDaemon forces the Messaging AppSlate to send text messages when the story needs them. This is the only time the GameDaemon interacts directly with an AppSlate, and it is only done through a direct reference from the PhoneControl's AppSlate dictionary. I'd think of a better way to couple them together, but it really didn't seem necessary to make a bridge object or something like that.

The GameDaemon currently doesn't do much. That's because it's intended to handle game progression and level scripting, two things I haven't done yet. However, the PhoneControl is designed to interface with the GameDaemon, so I've stubbed it out to facilitate that. Expect more documentation in the future

One thing the GameDaemon _might_ want to do in the future is use the current GameStoryBeat to create a little hint popup to guide the player on how to progress the game if they forget or get lost or become too distracted. And now that I think about it, it probably _should_ do that. But I'll do it later.

btw, _fields_ and _child nodes_ are _italics_, while **functions** and **signals** are **bold**.

### Fields
messanger_appslate: the appslate that sends text messages. The GameDaemon will need to send game-progression-relevant texts, so it maintains a reference to the messanger appslate to do so.

### Child Nodes
PhoneControl: the PhoneControl that the GameDaemon is using to produce GameStoryBeats.

## func _ready():
Calls **get_messanger_appslate()**.
	
## func get_messanger_appslate():
Assigned _messanger_appslate_. Currently, this is done by pulling whatever _PhoneControl_ has under GameEnums.AppSlateType.TEXT in the _PhoneControl.appslate_dict_ dictionary.


## func _on_game_story_beat_triggered(story_beat):
story_beat is type GameEnums.GameStoryBeat, but can't be typed that way. See GameEnums.md for more info on why.

This will evaluate story beats later on, but it does nothing for now.



