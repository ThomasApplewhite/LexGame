Here's how the signals and everything for GameStoryBeat need to work.

- GameDaemon needs to send a signal to the TextMessageAppSlate whenever it needs a new GameStoryBeat
		- DONE
- TextMessageAppSlate needs to send a signal to the ConversationEntryNodes whenever it needs a new GameStoryBeat
- ConversationEntryNode needs some way to receive required story beats from the conversation
	- DONE
- ConversationEntryNode needs some way to receive desired story beat frequency from the conversation
- ConversationEntryNode needs to be appropriately connected to the TextMessageAppSlate's GameStoryBeat signal
- ConversationEntryNode needs some way to figure out if the required GameStoryBeat has already happened
- ConversationEntryNode needs to update the convoslate's display conditions when the GSB signal from TextMessageAppSlate fires
	- DONE
- CoversationAppSlate's GameStoryBeatTriggered signal needs to fire whenever the a conversation should update a GameStoryBeat
- ConversatonAppSlate's GameStoryBeatTriggered signal needs to be connected to the main TextMessageAppSlate
- TextMessageAppSlate's GameStoryBeatTriggered needs to pass up to the phone
	- Basically, implement the intended signal chain of passing GameStoryBeats up to the phone and then to the GameDaemon from there.
