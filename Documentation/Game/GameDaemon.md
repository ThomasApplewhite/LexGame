# GameDaemon
extends Node

Also known as GameDaemonNode, the GameDaemon can be understood as a Game/LevelManager. The GameDaemon implements the progression of the game by expecting and reacting to certain GameStoryBeats in order. How it does this hasn't been implemented yet, but it will probably be a simple list of GameStoryBeats to iterate through in order.

The GameDaemon's primary purpose is to receive GameStoryBeat signals from the PhoneControl to decide if the game should progress. In addition to any other consequences of a GameStoryBeat (which I haven't decided on yet), the GameDaemon forces the Messaging AppSlate to send text messages when the story needs them. This is the only time the GameDaemon interacts directly with an AppSlate, and it is only done through a direct reference from the PhoneControl's AppSlate dictionary. I'd think of a better way to couple them together, but it really didn't seem necessary to make a bridge object or something like that.

The GameDaemon currently doesn't do much. That's because it's intended to handle game progression and level scripting, two things I haven't done yet. However, the PhoneControl is designed to interface with the GameDaemon, so I've stubbed it out to facilitate that. Expect more documentation in the future

One thing the GameDaemon _might_ want to do in the future is use the current GameStoryBeat to create a little hint popup to guide the player on how to progress the game if they forget or get lost or become too distracted. And now that I think about it, it probably _should_ do that. But I'll do it later.

btw, _fields_ and _child nodes_ are _italics_, while **functions** and **signals** are **bold**.

### Fields
export gsb_list_resource: GameStoryBeatList used to define the game order that the GameDaemon is going to follow.

onready phone_control: Stores a reference to _PhoneControl_

messanger_appslate: The appslate that sends text messages. The GameDaemon will need to send game-progression-relevant texts, so it maintains a reference to the messanger appslate to do so.

required_gsb_index: The index of the GameStoryBeat in the _gsb_list_resource_ that the GameDaemon is expecting. The index is stored, rather than the actual GSB, so that we don't need to specifically parse the GameStoryBeatList. It's just not necessary.

### Child Nodes
PhoneControl: the PhoneControl that the GameDaemon is using to produce GameStoryBeats.

## func _ready():
Checks to make sure that _gsb_list_resource_ is, in fact, a GameStoryBeatList, then sets _messanger_appslate_ to whatever the result of **get_messanger_appslate()** is.
	
## func get_messanger_appslate() -> Node:
Actually returns an Appslate, but that can't be used as a type hint

Returns _phone_control.appslate_dict[GameEnums.AppSlateType.TEXT]_, to access the _phone_control's_ current TextMessageAppslate

## func get_required_gsb() -> int:
Actually returns a GameStoryBeat, but that can't be used as a type hint.

Returns **gsb_list_resource.get_game_story_beat_at_index(required_gsb_index)**, to get the actual GameStoryBeat the GameDaemon needs. GameDaemon only stores the current index, _gsb_list_resource_ is what determines the actual GameStoryBeat.

## func advance_required_story_beat():
Increments _required_gsb_index_ by 1. If that new index is beyond the GameStoryBeatList's length (by checking if that index returns an EOF from **get_required_gsb()**), calls **end_game()**

## func end_game():
Currently does nothing. Will be used to move on to the end-game scene when that gets developed.

## func evaluate_game_story_beat(story_beat):
Checks if _story_beat_ is the same as the GameStoryBeat in **get_required_gsb()**. If they're the same, calls **advance_game_story_beat()**.

## func _on_game_story_beat_triggered(story_beat):
story_beat is type GameEnums.GameStoryBeat, but can't be typed that way. See GameEnums.md for more info on why.

Signal Receiver. Calls **evaluate_game_story_beat(story_beat)** whenever an attached signal activates.

