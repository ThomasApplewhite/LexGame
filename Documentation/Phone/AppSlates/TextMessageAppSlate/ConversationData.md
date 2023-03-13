# THIS DOCUMENT IS OUTDATED. SEE CONVERSATIONJSONTEXT.MD

# ConversationData

ConversationData isn't a 'class'; it's a JSON data asset. As such, there are no concrete definitions or specifications for how they work. Other than how ConversationParser parses the JSON file, of course.

ConversationData is an array of dictionaries containing various data fields, including a nested dictionary (itself containing an array of dicts), with each array entry (other than the first) representing a singular text message. The first entry in the array is the header. Right now they only required value is ConversationPartner, but any additional data needed for the file can go in there.

An example JSON file (with === where the data should be) is written at the bottom of the page. 

### JSON Fields
ConversationPartner: String. The person Lex is texting/messaging. This is the same for every message, so it goes in the header.

TriggerStoryBeat: String (converted to GameStoryBeat). The GameStoryBeat that the TextMessangerAppSlate should wait to receive before starting this message's 'sending time'. Mark as "NONE" to not wait for a GameStoryBeat and mark as "EOF" to flag that there are no more messages to send.

FirstPushTime: Float. The amount of time the TextMessangerAppSlate should wait before actually sending the text. The timer should start after the GameStoryBeat in TriggerStoryBeat is received.

PartnerMessageText: String. The actual message that the conversation partner will diplay.

ContainsPrompt: Bool (or, if not possible, String or Int converted to Bool). Whether or not this message includes a Prompt for the player to interact with.

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
		"TriggerStoryBeat": ===
		"FirstPushTime": ===
		"PartnerMessageText": ===
		"ContainsPrompt": ===
		"PromptContents":
		{
			"RepushTime": ===
			"PromptPhrases":
			[
				{
					"PhraseString": ===
					"Rows": ===
					"PhraseTime:" ===
				},
				{
					"PhraseString": ===
					"Rows": ===
					"PhraseTime:" ===
				},
				{
					"PhraseString": ===
					"Rows": ===
					"PhraseTime:" ===
				},
			]
		}
	},
	{
		"TriggerStoryBeat": ===
		"FirstPushTime": ===
		"PartnerMessageText": ===
		"ContainsPrompt": ===
		"PromptContents":
		{
			"RepushTime": ===
			"PromptPhrases":
			[
				{
					"PhraseString": ===
					"Rows": ===
					"PhraseTime:" ===
				},
				{
					"PhraseString": ===
					"Rows": ===
					"PhraseTime:" ===
				},
				{
					"PhraseString": ===
					"Rows": ===
					"PhraseTime:" ===
				},
			]
		}
	},
	{
		"TriggerStoryBeat": ===
		"FirstPushTime": ===
		"PartnerMessageText": ===
		"ContainsPrompt": ===
		"PromptContents":
		{}
	},
]
