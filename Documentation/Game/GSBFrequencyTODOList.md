OKAY I HAVE AN IDEA FOR FREQUENCY CHECKING

WHAT IF WE JUST DON'T

Think about it like this: Instead of checking at requirement creation time, just create the requirements. Then send a signal to TextMessageAppSlate that says "please tell me if these things have already occurred". The TextMessageAppSlate then calls evaluate_game_story_beat using whatever is in the frequency dict at that moment. How does TextMessageAppSlate have that information? I'm not sure yet but I'll figure it out later! Maybe it just does the same thing but with the GameDaemon directly!

Also lay out that mf node order! TIME FOR ANOTHER TODO!

6. Remember why I have GameStoryBeat frequency in the first place!
	- DONE! Check SpecificsOfGameStoryBeats.md for more detail.
1. Create the Node Hierarchy of TextMessageAppSlate
	- DONE! At least, as done as it needs to be for now.
1. Refactor ConversastionEntryNode to send a signal to TextMessangerAppSlate when it needs a notification, rather than calling methods on it directly.
	- DONE!
2. Create the Node Hierarchy of GameDaemon
	- DONE! Although this one was kinda cheating, since PhoneControl essentially _is_ GameDaemon's node heirarchy, and that's already set up. So, uh... good to go!
3. Create a Signal Loop for TextMessageAppSlate and ConversationEntryNode. ConversationEntryNode signals for frequency information, and TextMessageAppSlate calls evaluate_game_story_beat with whatever the current frequency from the signal'd story beat is.
	- I'm calling a "Signal Loop" a thing where a child node gets data from its parent by sending a signal and then the parent calls a method on the child to update the needed data.
	- DONE!
4. Create a Signal Loop for GameDaemon and TextMessageAppSlate. TextMessageAppSlate signals for frequency information, and GameDaemon calls... some method that provides it.
	- How will TextMessageAppSlate know which entries get with frequency informations? I don't know! But I'll figure it out later!
	- When text message appslate ask for info, it sends along which entry needs it, so that the return method also includes that info!
	- Even better, don't even loop! Just have GameDaemon tell the entry! Easy!
	- DONE	
5. Don't forget to doc along the way!
	- Potentially needs doc updates:
	1. GameDaemon
	2. ConversationAppSlate
	3. ConversationEntryNode
	4. ConversationParser
	5. TextMessageAppSlatge
	- DONE
7. Add the TriggerStoryBeatFrequency to convo_dicts, whatever that ends up looking like.
	- Okay, here's the plan: Each message requires a TriggerStoryBeat. That really isn't necessary, only some messages need Triggers. Most have a "NONE". So, here's the plan, for real:
		1. Replace the TriggerStoryBeat field with a dict that holds GSB -> Freq pairs. (OPTIONAL)
		2. Add a field to ConversationJSONText that specifies with GSB to send when the message is completed
		- DONE
		3. Change ConversationParser to parse the new dictionary (OPTIONAL)
		4. Change ConversationParser to parse the new JSONText
		- DONE
		5. Change ConversationEntryNode to support multiple required GSBs (OPTIONAL)
		6. Change ConversationEntryNode to send the update GSB signal.
8. Make it so that conversations actually trigger story beats lol.
	- DONE
8. TEST!
Make sure everything is still working
Add GSB syncing
Pray?
Document
Idk just figure it out.
9. TextMessageAppSlate might actually be done!


WRITE DOWN THE FULL FUNCTIONALITY CHAIN FOR CHECKING STORY BEATS BEBCAUSE i WILL FORGET!
ACTUALLY WRITE EVERYTHING OUT FOR HOW STORY BEATS PROGRESS BEFFORE TESTING AGAIN! YEAH!