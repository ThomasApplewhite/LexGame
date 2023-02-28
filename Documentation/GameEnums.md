Write down how enums are 2nd class citizens so global scope enums arent a thing and they need their own seperate class_name'd script to be accessible in multiple scripts

this github discussion explains it well
https://github.com/godotengine/godot-proposals/issues/240

but tl;dr no enum type hints. sorry lol.

# GameEnums
extends Object

GameEnums is a utility class that holds definitions for game-wide Enums. Enums in Godot are not first-class types, so they can only be used in the class in which they are defined and scripts that load the class in which they are defined. By class_name-ing GameEnums (which essentially loads it in every script), enums defined in GameEnums can be used anywhere, allowing classes to communicate to each other using enums.

This is sufficient for everything _except_ function and field type hints. This workaround does not actually define the enums as types, it simply allows enum values to be referenced in code. The type itself is still exclusive to GameEnums, so Godot will not recognize GameEnums enum types as valid in function definitions. This is why functions that expect enums as arguments have type hints as comments, not as definitions. And, yes, I probably _could_ type hint them all as ints, but I feel that'd be more confusing then not having a type hint at all.

GameEnums is a class_name'd type. It can't be instanced _at all_.

## enum AppSlateType
Each value represents a derived type of AppSlate for easier referencing between the PhoneControl and the AppSlates.

## enum GameStoryBeat
Each value represents a type of GameStoryBeat that can occur during the game. Note that a GameStoryBeat can occur multiple times from different sources.

GameStoryBeats are part of game progression, which hasn't been developed yet. This type is only here as a stub for PhoneControl and AppSlate testing. Thus, the only values for this enum right now are DEBUG, EOF, and NONE.

## static func string_to_gamestorybeat(enum_string : String) -> int:
Defines a local String->GameStoryBeat enum that maps a CamelCase string to the GameStoryBeat enum of the same name. Returns the dictionary value of _enum_string_ when used as a key, or NONE if there is no match.


