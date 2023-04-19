OKAY I HAVE AN IDEA FOR FREQUENCY CHECKING

WHAT IF WE JUST DON'T

Think about it like this: Instead of checking at requirement creation time, just create the requirements. Then send a signal to TextMessageAppSlate that says "please tell me if these things have already occurred". The TextMessageAppSlate then calls evaluate_game_story_beat using whatever is in the frequency dict at that moment. How does TextMessageAppSlate have that information? I'm not sure yet but I'll figure it out later! Maybe it just does the same thing but with the GameDaemon directly!

Also lay out that mf node order! TIME FOR ANOTHER TODO!

6. Remember why I have GameStoryBeat frequency in the first place!
- DONE! Check SpecificsOfGameStoryBeats.md for more detail.
1. Create the Node Hierarchy of TextMessageAppSlate
2. Create the Node Hierarchy of GameDaemon
3. Create a Signal Loop for TextMessageAppSlate and ConversationEntryNode. ConversationEntryNode signals for frequency information, and TextMessageAppSlate calls evaluate_game_story_beat with whatever the current frequency from the signal'd story beat is.
	- I'm calling a "Signal Loop" a thing where a child node gets data from its parent by sending a signal and then the parent calls a method on the child to update the needed data.
4. Create a Signal Loop for GameDaemon and TextMessageAppSlate. TextMessageAppSlate signals for frequency information, and GameDaemon calls... some method that provides it.
	- How will TextMessageAppSlate know which entries get with frequency informations? I don't know! But I'll figure it out later!
5. Don't forget to doc along the way!
7. Add GSB Frequencies to convo_dicts, whatever that ends up looking like.
8. TEST!
9. TextMessageAppSlate might actually be done!