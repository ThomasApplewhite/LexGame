# ConversationJSONText
extends Resource

For reasons beyond me, Godot can't serialize normal text files as assets. But it *can* define custom asset types that save text data as strings.

ConversationJSONText is a Resource wrapper around a single _json_text_ field, which holds the actual JSON string of the conversation. Since Godot's JSON parser expects the JSON as a raw string anyways, this is sufficient for saving conversation content as an asset in a (semi-)human-readable and -writable way.

The ConversationData itself is an array of dictionaries containing various data fields, including a nested dictionary (itself containing an array of dicts), with each array entry (other than the first) representing a singular text message. The first entry in the array is the header. Right now they only required value is ConversationPartner, but any additional data needed for the file can go in there.

An example JSON file (with === where the data should be) is written at the bottom of the page. 

ConversationJSONText is a class_name'd type, so as to be compatible with how Resources need to be defined for serialization. I... think

### Fields
json_text: The actual JSON text of the conversation. Exported as a MULTILINE String for ease of editing within the inspector and individual .tres files.

## func _init():
Constructor. Does nothing, but I think this needs to be defined for the Resource to work as an asset.

## func get_text() -> String:
Accessor. Not defined as a setget for... export reasons? Not sure. It doesn't really matter.
return _json_text_

## func is_type(type): 
Overrides the default **is_type(type)** to use this type's more specific type. 
return _type_ == **get_type()**

## func get_type(): 
Overrides the default **get_type()** method so that this type's type is more specific than 'Resource'
return "ConversationJSONText"

### JSON Fields
ConversationPartner: String. The person Lex is texting/messaging. This is the same for every message, so it goes in the header.

TriggerStoryBeat: String (converted to GameStoryBeat). The GameStoryBeat that the TextMessangerAppSlate should wait to receive before starting this message's 'sending time'. Mark as "NONE" to not wait for a GameStoryBeat and mark as "EOF" to flag that there are no more messages to send.

SendStoryBeat: String (converted to GameStoryBeat). The GameStoryBeat that the ConversationEntryNode will send when once the message has been sent. Mark as "NONE" if the message doesn't send any GameStoryBeats.

FirstPushTime: Float. The amount of time the TextMessangerAppSlate should wait before actually sending the text. The timer should start after the GameStoryBeat in TriggerStoryBeat is received.

PartnerMessageText: String. The actual message that the conversation partner will diplay.

ContainsPrompt: Bool (Which are all lowercase in JSON). Whether or not this message includes a Prompt for the player to interact with.

PromptContents: Dictionary. If this ConversationChunk has a Prompt, contains all of the data needed to construct a PromptSettings (and other stuff to represent Lex's message). If there is no ConversationChunk, this will be empty. 

RepushTime: Float. The amount of time to wait until an additional notification should be sent to remind the player to play the Prompt.

PromptPhrases: Array of Dictionaries. Contains individual PromptPhrase information. These will be combined to create a PromptSettings.

PhraseString: String. The sentence Lex is messaging in this part of the Prompt.

Rows: Int. The number of button rows used in this phrase

PhraseTime: Float. The amount of time the player has to complete the phrase before it automatically fails.

### Format Spec
[
	{
		"ConversationPartner": ===
	},
	{
		"TriggerStoryBeat": ===,
		"SendStoryBeat": ===,
		"FirstPushTime": ===,
		"PartnerMessageText": ===,
		"ContainsPrompt": ===,
		"PromptContents":
		{
			"RepushTime": ===,
			"PromptPhrases":
			[
				{
					"PhraseString": ===,
					"Rows": ===,
					"PhraseTime:" ===
				},
				{
					"PhraseString": ===,
					"Rows": ===,
					"PhraseTime:" ===
				},
				{
					"PhraseString": ===,
					"Rows": ===,
					"PhraseTime:" ===
				}
			]
		}
	},
	{
		"TriggerStoryBeat": ===,
		"SendStoryBeat": ===,
		"FirstPushTime": ===,
		"PartnerMessageText": ===,
		"ContainsPrompt": ===,
		"PromptContents":
		{
			"RepushTime": ===,
			"PromptPhrases":
			[
				{
					"PhraseString": ===,
					"Rows": ===,
					"PhraseTime:" ===
				},
				{
					"PhraseString": ===,
					"Rows": ===,
					"PhraseTime:" ===
				},
				{
					"PhraseString": ===,
					"Rows": ===,
					"PhraseTime:" ===
				},
			]
		}
	},
	{
		"TriggerStoryBeat": ===,
		"SendStoryBeat": ===,
		"FirstPushTime": ===,
		"PartnerMessageText": ===,
		"ContainsPrompt": ===,
		"PromptContents":
		{}
	},
]
