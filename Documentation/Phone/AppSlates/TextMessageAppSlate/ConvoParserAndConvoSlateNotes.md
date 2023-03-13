The 'Convo'Slates interact with their ConversationPartner with the following loops:

1. Slate asks parser for the next piece of text. Any setup that needs to be done with the associated data is done here.
2. Slate starts the 'first push timer'
3. Question: Does Lex need to respond to this message?
---NO---
4. The push notification is sent and the text is added to a 'convo' stack
5. Back to Step 1!
---YES---
6. A PromptControl is created for the prompt, and is shown whenever the slate is open
7. Start the 'repush timer', which is the timer that determines when additional push notifications should be sent to lex's phone. This one repeats! At least until the prompt is completed.
8. Wait for the prompt to be completed...
9. Push the prompt's non-interactive text as a message from the convo partner to the stack and Lex's response as a message from him to the convo stack
	Lex's response will be pre-written into the data structure the convo-slate receives from the ConversationParser.
10. Back to the top!




the 'first push timer', which is how long to wait before actually displaying the text in the conversation and then pushing a notification that the text has been received

'repush timer', which is the timer that determines when additional push notifications should be sent to lex's phone. This one repeats! At least until the prompt is completed

a 'convo' stack that roughly manages how the texts are displayed
	How the convo stacks are used to print text message visuals are not my problem right now.

OKAY! SO! THAT'S HOW THEY INTERACT! WHAT DOES THE CONVOPARSER ACTUALLY NEED???????

* A constructor that takes one of those fancy conversation data assets as an argument
* A parsing method that turns the data in the conversation asset into a nicely managed stack of ConversationChunks.
* ConversationChunks! To be described below
* A method that, when called, returns either the next ConversationChunk of text information for the slate to read, or some sort of EOF chunk to tell the convoslate that we're out of data and to go away
	- It may be useful to have assets chunk out some repeatable things to text to be annoying, but that's out of scope for right now.
* A function that returns the actual _person_ being conversed with in this chunk. That's important!
	- This might also need to include any other 'header' information that may be relevant to the conversation, but for now it's just the name.
* A stack to hold all the Conversation chunks while it waits for the game to play.

And the ConversationChunks are important too! But they're just structs, no functionality. They contain this data:
* TriggerStoryBeat: Some sort of Enum that indicates what GameStoryBeat needs to come down from the GameDaemon before this message can be sent
	- If this value is NONE, there is no trigger and the chunk doesn't need to wait
	- If this value is EOF, there is no trigger and no more text to print, so stop asking.
* FirstPushTime: How many seconds the ConvoSlate should wait after receiving this data to actually add it to the stack and send a push notification over it
* PartnerMessageText: A formatted string of what the conversation partner just texted
* ContainsPrompt: Whether or not we want to generate a Prompt for this ConversationChunk.
---If ContainsPrompt is False, the following fields will be empty---
* RepushTime: How many seconds the ConvoSlate should wait after creating/posting/pushing/whatever the prompt before sending _another_ push notification to annoy Lex with so he (they?) actually does the Prompt
* PromptSettings: The PromptSettings the ConvoSlate will actually use to create the Prompt.

And, one more time, how the ConvoSlate displays its Conversation Stack is up to the ConvoSlate and not relevant to the conversation parser.