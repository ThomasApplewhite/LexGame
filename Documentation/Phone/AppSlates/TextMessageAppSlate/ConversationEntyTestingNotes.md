The following files will need a documentation refresh once ConversationEntry testing is done:
- ConversationEntry
- ConversationAppSlate
- ConversationParser

ConversationEntry isn't working right off the bat in testing. These are my notes on that, mostly from my whiteboard.

First, as soon as ConvoEntry is done, GameDaemon needs to be made, not the TextMessageAppSlate. I've skipped over storybeat checking too much and tbh I should just make the GameDaemon instead of mocking it out.

You should also explicitly document the relationship between ConversationEntry and ConversationAppslate and TextMessageAppSlate in something other than the wacky scratch notes you have on conversations in general. Actually, after ConversationEntry, condense down your docs on TextMessageAppSlate first.

Right now, primary issue with ConversationEntry is not the entry itself, but that the UI formatting on ConversationAppSlate makes it impossible to see the text, since the RichTextLabels get smashed into nothingness. Spend some time organizing the UI with some dummy labels, then once you get the settings right, make either a RichTextLabel formatting function OR maybe even better create a RichTextLabel scene that is just a RichTextLabel with all the settings already set up. That way if you want to add move visuals to them later you don't have to do extra work. Doc it once you're done with testing.