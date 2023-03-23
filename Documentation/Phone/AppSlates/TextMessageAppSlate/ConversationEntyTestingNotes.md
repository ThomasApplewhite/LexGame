The following files will need a documentation refresh once ConversationEntry testing is done:
- ConversationEntry
- ConversationAppSlate
- ConversationParser

ConversationEntry isn't working right off the bat in testing. These are my notes on that, mostly from my whiteboard.

First, as soon as ConvoEntry is done, GameDaemon needs to be made, not the TextMessageAppSlate. I've skipped over storybeat checking too much and tbh I should just make the GameDaemon instead of mocking it out.

You should also explicitly document the relationship between ConversationEntry and ConversationAppslate and TextMessageAppSlate in something other than the wacky scratch notes you have on conversations in general. Actually, after ConversationEntry, condense down your docs on TextMessageAppSlate first. Also document the differences between all the varying convo dicts in ConversationAppSlate

Right now, primary issue with ConversationEntry is not the entry itself, but that the UI formatting on ConversationAppSlate makes it impossible to see the text, since the RichTextLabels get smashed into nothingness. Spend some time organizing the UI with some dummy labels, then once you get the settings right, make either a RichTextLabel formatting function OR maybe even better create a RichTextLabel scene that is just a RichTextLabel with all the settings already set up. That way if you want to add move visuals to them later you don't have to do extra work. Doc it once you're done with testing.

Bugs that have been picked up:
- Okay this isn't a bug, but when the appslate starts the first message takes 3 seconds to appear. That's how it's supposed to be.
- Several parts of the ConversationAppSlate/Entry use class variables that should really be checker methods that check properties of things (like the is_convo_slate_active, that shouldn't be a bool, that should be a function to check if the actual slate is active or not

The ConversationAppSlate should really be tested in isolation without the ConversationEntryNode before I move forward. 

Also, did I intend the ConversationAppSlate to explicitly use the phone's make_active_appslate method?

Fixed a bug where ConvoAppSlate wasn't ready to start because it was started before it was added to the scene tree. I fixed it by making sure it was added to the scene tree before starting. But now there's a new bug where the active convo dict isn't updated correctly after the first entry. One of those things that needs to be fixed by data-driven indicies of things, not by raw variables.