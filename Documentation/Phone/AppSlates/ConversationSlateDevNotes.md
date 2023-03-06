ConversationSlates need to handle all the visualizing for a conversation slate. They should be fancier, cleaner, and more efficient versions of the parser tester that was made. Once that is done, integrate it with conversation slates.

But remember! Timers need to persist on the TextMessageAppSlate, not the conversation slate! So part of the conversation slate's handling needs to be passed up to TextMessageSlate, or whatever.

In addition to all the stuff that the Tester does:
- Have an export slot for a conversation resource
- Have a preload slot for PromptControl and ConversationParser
- Manage the convo_dict, the parser, and the active Prompt (if any)
- Format/organize text messages and prompts
- actually do data parsing
- Setup timers and wait for appropriate story beats
- Send notification messages
- Create PromptControls
- Intercept Prompt Completed signals

The ConvoSlate also needs to:
- Ask the text slate to make it the active appslate
- Have some way of attaching timers for notifs to the ConvoSlate (remember ConvoSlates are _not_ intended to persist in the background
- Receiving story beats from the phone
- _Somehow_ persist the state of the conversation between instances of the same conversation. Somehow...
- Delay text activation until story beats are recieved

On that idea of persisting data and timers: what if conversation slate had a special 'parent' node that held its data and timers: a part that _did_ persist. It wouldn't carry all of the data, though. It could hold:
- timers
- conversation messages already sent (or, at least, their indices)
- conversation data paths
- _maybe_ cached parser data. It's be a lot to hold onto... Maybe...
	* No, reparse every time. A load on a text message click is realistic.
- The text of the previous message. To show as a preview on the phone, maybe.

Okay, here's an idea:
The TextMessageAppSlate will have a list of Conversation Manager Nodes, one for each conversation parser. These nodes are where you set the correct reference path for the conversation. When a conversation is clicked on, the manager/data/whatever node will spawn the actual convo appslate and pass it the asset to parse and all that. The Convo slate will do the parsing and conversation loading and all the rest.
When the conversation is closed, before the appslate switch happens (remember, TextMessageAppSlate can control the pace of things here by modifying the appslate button signal receiver), the manager/data/whatever node will gather up (somehow?) the messages that have already been sent in a way that is data-easy. When the conversation is reopened, the manager/data/whatever node will tell the convoslate to fast-forward the conversation to the point it last had saved.
Oh, and all of the notif timer signals can probably go on the manager too, since they need a host to persist to receive their signals.

So the ConversationEntryNode is the persistant data holder and signal handler for the ConversationSlate.

The ConversationSlate handles parsing resource data provided by the ConversationEntryNode and displaying it on screen.

The TextMessageAppSlate handles signals from the phone and moves between conversation entries.

EntryNode _could_ handle parsing and poping, but we don't want that data to persist. Once everything is setup, it should be 100% on the conversation slate to drive things

You have a picture on your phone that details how all of these things should interact.

The only _uncertain_ area now is how the notification signals should be handled. All of the data for them needs to end up on the ConversationEntryNode, but how should it stay consistent with itself? I mean, like, how should that data be stored?

Eh. Whatever. I'll figure that out when I get there. The important part is is that _all_ notification related data should be pushed to the ConvoEntry.

I do also need to start identifying specific chunks by some sort of identifier. So... maybe I just have the convo dicts include an index value now? Sure, that works. Lotta changes, tho. I'll do that as a seperate commit.

Need to decide how I want to do indicies of prompt entries. I can probably just add an index value to each dictionary entry.
yeah it's that easy  lol.lmao

OKAY! ConversationAppSlate is written! Need to do convo entry and then I can doc and test!