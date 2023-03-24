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

Okay! I've removed subarray splitting entirely and just pop the pre-done dicts manually, and the other index bugs seem to be fixed by making the active_convo_index a data-based get. So mostly its good!

Only remaining bugs is that the last message in the conversation and prompts in the conversation have their first timers reset on reload. For prompts, that makes sense. The "incoming text" when the slate is closed has to be recreated, and prompts count as "incoming" (active but not displayed) while they are playing. Perhaps a specific edge case exception will be made for that. I'm not sure why it happens with the last item in the conversation

I am also unsure of how the entry will handle first push timers expiring while the slate is off. How long should it wait to advance the next index if a first push fires while the slate is off? Do the indicies in the entry even fire correctly? I should check.

But, for right now, I'm not going to fix this. These bugs are not super serious, and I think there are more important features to do right now. I'm going to update the tested conversation doc, condense down the notes I have on ConversationAppSlate and its related stuff, and then move on to GameDaemon. But I'll make sure to make a note somewhere to fix this. Or maybe I'll just notice again. I should put this stuff into spreadsheets sometimes. I'm basically reinventing basic dev practices for small teams before cloud production was a thing!