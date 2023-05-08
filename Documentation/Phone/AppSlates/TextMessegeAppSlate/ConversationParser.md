# ConversationParser
extends Reference

ConversationParser is a utility class designed to parse ConversationData JSON text assets into data structures to be used by the TextMessengerAppSlate. After parsing the JSON data into an array of data dictionaries, the ConversationParser provides individual message data in a stack-like manner: data is given in order as defined in the file and only once. Once the ConversationParser is out of data, it will return empty(ish) dicts to indicate that the conversation is over.

The dictionaries that the ConversationParser returns are _not_ explicit data structures, just duck-typed String->(probably) String dictionaries. They're referred to as Conversation Chunks or convo_dicts within code. They contain the following information with the following JSONFields enum keys (the JSONFields enum is documented under **Fields**):

TRIGGERSTORYBEAT: The GameEnums.GameStoryBeat that the TextMessengerAppSlate should wait to receive before sending this message.
SENDSTORYBEAT: The GameEnums.GameStoryBeat that the TextMessengerAppSlate will recieve when this message is sent.
FIRSTPUSHTIME: The amount of time the TextMessengerAppSlate should wait before sending this message and its push notification
PARTNERMESSAGETEXT: The text of the message that Lex recieves from the conversation partner
CONTAINSPROMPT: Whether or not this message comes with a Prompt that Lex needs to complete to advance the conversation
REPUSHTIME: The amount of time the TextMessengerAppSlate should wait before sending another push notification to remind Lex to complete the prompt
LEXMESSAGETEXT: The text to print out from Lex once the prompt has been completed
PROMPTSETTINGS: The PromptSettings object used to construct the prompt.

btw, _fields_ and _child nodes_ are _italics_, while **functions** and **signals** are **bold**.

### Fields
JSONFields: an emum that holds all of the fields we expect from the JSON dicts that JSON.parse returns. While not directly applicable (as the JSON dict is keyd with strings, not ints/enums), these enums allow for consistent, type-safe accessing of data across ConversationParser and any class that loads it. This enum contains more values than are listed in the dictionary key list above, as there are some fields in the JSON specification that don't directly translate into the final data dictionary.

ESA: Stands for 'Enum to String Accessors', but is shortened for readability. Explicitly matches a JSONFields enum to the string that it represents in the JSON for easy, non-literal accessing. This dict doesn't contain a matching for every JSONFields value, since not all of them are used to access the JSON results dictionary.

json_file_resource: The ConversationJSONText used for this parser. This is provided in the constructor.

conversation_chunks: The stack of Conversation Chunks representing this conversation. Values are popped off the front as needed by whatever is displaying/handling the conversation.

conversation_partner: The name of the other person in the conversation.

## func _init(new_json_file_resource : ConversationJSONText):
Constructor.	
_json_file_resource_ = _new_json_file_resource_

## func parse_json_file():
Executes the file reading and JSON parsing process:

1. Calls _file_text_ = **read_json_file()**
	If _file_text_ is empty after is, that means there was a file read error, so we return at this point if it is
2. Parse the result of the read with _json_result_ = **JSON.parse(file_text)**
	**JSON.parse** is a native Godot Class/Method
3. Handle errors. If _json_result.error_ is anything other than 0, the error is printed out and the parsing immediately ends
4. Read the header value. Because the JSON header item is always the first value of the JSON dict, we pop the front of the _json_result_ and parse it as a header with **parse_header_item(json_result.result.pop_front())**. After this, only ConversationChunk data remains in the results array.
5. For each remaining _result_item_ in _json_result.result_, **parse_json_item(result_item)**, then push it to the back of _conversation_chunks_.

And that's about it!
	
## func read_json_file() -> String:
returns **json_file_resource.get_text()**

This is what it did when the JSONs were literal JSON files, and not a type of custom reference:
Creates, opens, reads, and closes a File to read ConversationData from. Most of this method is calling Godot's File methods to do the file reading, so this method is primarily responsible for error handling. In the event of an error, an empty string will be returned.

## func parse_json_item(convo_item) -> Dictionary:
The primary algorithm of the parser. This is where the JSON string data is saved as something usable by the TextMessageAppSlate, _convo_dict_. It goes something like this:

1. Check to see if _convo_item_ is empty/null. If it is, then there was a parsing error. An error is pushed and an empty dict is returned. If not, continue.
2. Read out the 'guaranteed' data of the JSON file: all of the information in the JSON dict that each conversation_chunk will have. The following is always saved to the final _convo_dict_:
	- TRIGGERSTORYBEAT
	- SENDSTORYBEAT
	- FIRSTPUSHTIME
	- PARTNERMESSAGETEXT
	- CONTAINSPROMPT
	- CONVERSATIONINDEX
3. If there's no Prompt associated with this text message (CONTAINSPROMPT is false), the algorithm is finished and the _convo_dict_ is returned. If not, continue.
4. Process each individual phrase of the Prompt associated with the text message. A secondary _prompt_dict_ is created to hold prompt-specific data inside the _convo_dict_, as well as a _lex_response_ to hold Lex's message and _lex_phrase_settings_ to hold PromptPhrases once the prompt is over. The prompt-specific Prompt Contents of _convo_item_ is stored in _convo_prompt_contents_ for easier access.
5. Each phrase is processed in a separate loop:
	1. Save out the raw data of the JSON phrase:
	- PROMPTPHRASES
	- PHRASESTRING
	- ROWS
	- PHRASETIME
	2. Append the PHRASESTRING to the _lex_response_
	3. Split up Lex's phrase based on spaces and separated into an array of strings. This is how PromptPhrase expects Lex's text.
	4. Use the saved data from Step 5-1 to create a PrompPhrase, and push it to _lex_phrase_settings_.
6. All of the phrases are now done! Create the PromptSettings using the information saved from all of the phrases.
7. Save the following information to the _prompt_dict_:
- REPUSHTIME
- LEXMESSAGETEXT
- PROMPTSETTINGS
8. Save the _prompt_dict_ to the _convo_dict_ under PROMPTCONTENTS
9. Return the _convo_dict_. All done!
	
## func parse_header_item(header_dict):
Parses information from the JSON header dict. Right now, that only means saving the _header_dict_ "ConversationPartner" to conversation_partner. We do know, though, that if _header_dict_ is empty, then there was some sort of parsing error. So, we he acknowledge that here for safety's sake.

## func _get_conversation_parter() -> String:
Getter method for _conversation_partner_.
return _conversation_partner_

## func get_next_conversation_chunck() -> Dictionary:
Pops a conversation dict off of the front of _conversation_chunks_ and returns it. If there are no _conversation_chunks_ left, an empty dict will be return. The only field with data will be TRIGGERSTORYBEAT, which will read EOF.