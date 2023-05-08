The Text Message Appslate needs several different scripts/nodes/classes to work as a singular whole. Those classes are
- ConversationJSONText
- ConversationParser
- ConversationAppSlate
- ConversationEntry
- TextMessageAppSlate

And they work like this:

The TextMessageAppSlate _will_ have several child ConversationEntry nodes, one for each person who will text Lex. Which person goes to which entry is determined by the inspector-defined ConversationJSONText of the ConversationEntry.

ConversationJSONText is a resource asset that contains a singular JSON-formatted string. This string defines a dictionary that contains all the information for a conversation. 

When a ConversationEntry is told to show its conversation (this isn't implemented yet) it will create a ConversationAppSlate. The ConversationAppSlate will be initialized with the ConversationJSONText from the ConversationEntry, as well as state data from the last time the ConversationAppSlate was active (data that also comes from the ConversationEntry).

The ConversationAppSlate will create a ConversationParser to parse the ConversationJSONText, and then take care of all conversation gameplay until the ConversationEntry is told to end the ConversationAppSlate. Other than creating timers for notifications, the ConversationAppSlate is responsible for all of the actual gameplay.

When a ConversationEntry is told to hide its conversation (this isn't implemented yet), its ConversationAppSlate will be destroyed, and some of the ConversationAppSlate's state data will be saved for the next time it appears.

This system has some notable bugs:
- ConversationEntries cannot progress inactive conversations past their first non-prompt conversation chunk, which they should be able to
- If a prompt is the active conversation chunk when a ConversationAppSlate is removed, the player will need to wait for its FirstPushTimer to re-elapse before it appears again. Active prompt chunks should appear immediately.