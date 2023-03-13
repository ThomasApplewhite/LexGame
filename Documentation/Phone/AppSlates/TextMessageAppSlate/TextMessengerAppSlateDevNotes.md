The Text Slate needs to do three things:
1. Have a list of all texted contacts that are selectable to pick a specific conversation.
2. Display a conversation history for each contact so that things can be kept up with.
3. Display PromptControls that are needed for resolving certain conversations.
4. Send notifications when texts aren't periodically responded to.

That's a lot of work to do lol, especially to get the PromptControls to fit. I'm sure it'll be fine though. But this is the first slate to do because it is the hardest and the most important.

Okay, here's a funny idea: The various pages of the textmessenger fit in the phone much like an appslate, except they only need to exist when loaded...
Could the various pages of the textmessenger be appslates? They'd need special relationships with the actual TextMessenger and bindings because really all of the signals sthese sub appslates need to make should be handled exclusively by the textmessenger...

Okay, Idea: The TextMessengerAppSlate is just a contact list. When a contact is  tapped, that becomes the 'active convo' and the TextMessengerAppSlate will replace itself with a *generated* appslate that represents the conversation. If the conversation is left, it is deleted. Again, the 'convo' appslate holds no data, only the TextMessengerAppSlate. The TextMessengerAppSlate will pass this slate into the convo to generate it tho. So.. yeah...

TextMessengerAppSlate needs to know:
if it's in contact list mode or displaying a convo
if a convo is being displayed, who the convo is with
the current convo appslate
the convo appslate scene
some way to tell which convos need notifications when
data for each convo
a structure to hold data for each convo
	this may need an additional struct type or something to hold this info now that we're getting into the nittygritty of conversations, that'll be figured out later

TextMessengerAppSlate needs to do:
all of the appslate signalling
convo appslate generation and parenting
saving information from convo appslates as conversations advance.
some way to advance conversations
	maybe that too can be handled by the conversation struct? hmm...
that's really it huh. Single Responsibility, nice!

Okay so this conversation struct. Pull the responsibility for managing the convos and timing out of TextMessengerAppSlate and put it somewhere else
Well okay if it's got significant functionality this should probably be a class but whatever. 
This convo class can keep track of:
Literal Conversation Text
Conversation Text Ordering
Timing Notifications
!!! Prompt Text !!! This can be what holds the prompts!
And if I want to get wavy with how the conversation text is held, I can have this conversation class take a text asset with some markdown that formats itself into the conversation class. That way the game can be localized! Cool! And it makes writing out all of the conversations way easier lol.

So to sum all of this up (goodness I could use a chart...)
TextMessengerAppSlate picks individual conversations to have and relays text messege stuff to the phone
ConversationAppSlate displays the conversation text and manages Prompts when they're required in conversations
Conversation... ObjectClassThing contains all of the text/info for a conversation (and how it _must_ go) and times when notifications are needed. Lmao it needs a parser.
ConversationTextData contains the literal written text of the conversations, plus some markdown to help format the text into the ConversationObjectClassThing.

Goodness... where to start... probably...
1. ConversationObjectClassThing
2. ConversationTextData
3. TextMessengerAppSlate
4. ConversationAppSlate

I should keep this doc lol it's a goldmine of nonsense it is USELESS lol just screamy dev thoughts.

Is this overengineered? Maybe. But overengineering is ***fun***.

Turns out that all objects in Godot can do signals. So, TextMessengerAppSlate will probably just hold a container of ConversationTextDatas that will be used to feed a bunch of Conversation... Reference? Monitor? Runner? What is it? It's not a conversation entirely...
Parser! ConversationParser!
