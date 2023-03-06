extends Reference

# This enum defines the various fields that are used by the json for easy
# debugging and reading
# We can also use these enums wherever this class is loaded, including in
# the convo slates, so we use this for all accessing
enum JSONFields {
	CONVERSATIONINDEX,
	CONVERSATIONPARTNER,
	TRIGGERSTORYBEAT,
	FIRSTPUSHTIME,
	PARTNERMESSAGETEXT,
	CONTAINSPROMPT,
	REPUSHTIME,
	PROMPTPHRASES,
	PHRASESTRING,
	ROWS,
	PHRASETIME,
	ERROR,
	LEXMESSAGETEXT,
	PROMPTSETTINGS,
	PROMPTCONTENTS
}

# And this dict translates those enums into strings
# I see mentions of string enums in Godot around, but I don't know how to write
# them out, so dicts for now lol.
# I know ESA isn's a great name, but I need this for readability's sake.
var ESA = {
	JSONFields.CONVERSATIONPARTNER 	: "ConversationPartner",
	JSONFields.TRIGGERSTORYBEAT 	: "TriggerStoryBeat",
	JSONFields.FIRSTPUSHTIME 		: "FirstPushTime",
	JSONFields.PARTNERMESSAGETEXT 	: "PartnerMessageText",
	JSONFields.CONTAINSPROMPT 		: "ContainsPrompt",
	JSONFields.PROMPTCONTENTS		: "PromptContents",
	JSONFields.REPUSHTIME			: "RepushTime",
	JSONFields.PROMPTPHRASES		: "PromptPhrases",
	JSONFields.PHRASESTRING			: "PhraseString",
	JSONFields.ROWS					: "Rows",
	JSONFields.PHRASETIME			: "PhraseTime",
	JSONFields.ERROR				: "Error"
}

var json_file_resource : ConversationJSONText

var conversation_chunks = []

var working_index = 0

var conversation_partner : String setget , _get_conversation_parter

func _init(new_json_file_resource : ConversationJSONText):
	json_file_resource = new_json_file_resource

# This will be called to manually start the parsing
func parse_json_file():
	var file_text = read_json_file()
	
	if file_text.empty():
		return
	
	var json_result = JSON.parse(file_text)
	
	if json_result.error:
		# man godot string formatting sucks
		var error_text = "ConversationParser.parse_json_file(): Error Parsing JSON: "
		var err_dict = {
			"code" : json_result.error,
			"line" : json_result.error_line,
			"errr" : json_result.error_string
		}
		error_text += "Code: {code}, Line {line}, String {errr}".format(err_dict)
		push_error(error_text)
		return
	
	# The JSON result will be an array.
	# The first value is the header, so we handle that seperately
	parse_header_item(json_result.result.pop_front())
	
	# We then parse each remaining result item into the conversation chunk
	for result_item in json_result.result:
		var new_convo_chunk = parse_json_item(result_item)
		conversation_chunks.push_back(new_convo_chunk)
		
	# and that's it!
	
func read_json_file() -> String:
	return json_file_resource.get_text()
	
	# The below reader text was used back when the json_file was a literal
	# JSON file, not a resource type
	#var json_file = File.new()
	#var error = json_file.open(json_file_path, File.READ)
	#if error:
	#	push_error("ConversationParser.read_json_file: Error reading file %s with code %d".format([json_file_path, error]))
	#	json_file.close()
	#	return ""
	#	
	#var text = json_file.get_as_text()
	#json_file.close()

	#return text

# The one time duck typing is useful! No need (or desire) to type this!
func parse_json_item(convo_item) -> Dictionary:
	if !convo_item:
		push_error("ConversationParser.parse_json_item: convo_item is null, JSON result is valid but empty!")
		return {}
	
	#Anyways, I'm about to do what we call, a 'pro gamer move'.
	var convo_dict = {}
	
	# Save the guartuneed fields into the dict.
	var gsb_data = convo_item[ESA[JSONFields.TRIGGERSTORYBEAT]]
	convo_dict[JSONFields.TRIGGERSTORYBEAT] = GameEnums.string_to_gamestorybeat(gsb_data)
	convo_dict[JSONFields.FIRSTPUSHTIME] = convo_item[ESA[JSONFields.FIRSTPUSHTIME]]
	convo_dict[JSONFields.PARTNERMESSAGETEXT] = convo_item[ESA[JSONFields.PARTNERMESSAGETEXT]]
	convo_dict[JSONFields.CONTAINSPROMPT] = convo_item[ESA[JSONFields.CONTAINSPROMPT]]
	
	# If there's no prompt involved, we don't actually need to do any parsing. We can just
	# return the dict and be done.
	if !convo_dict[JSONFields.CONTAINSPROMPT]:
		return convo_dict
	
	# We do have a prompt? Cool. We need to construct Lex's entire response AND
	# the PromptSettings needed to create the Prompt when the time comes
	var convo_prompt_contents = convo_item[ESA[JSONFields.PROMPTCONTENTS]]
	var prompt_dict = {}
	var lex_response = ""
	var lex_phrase_settings = []

	# create PromptPhrase for each phrase item in the json
	for phrase_dict in convo_prompt_contents[ESA[JSONFields.PROMPTPHRASES]]:
		# save out the entire dict
		var lex_string = phrase_dict[ESA[JSONFields.PHRASESTRING]]
		var rows = phrase_dict[ESA[JSONFields.ROWS]]
		var phrase_time = phrase_dict[ESA[JSONFields.PHRASETIME]]
		var lex_phrase
		
		# append the phrase string to lex's total response with a space for formatting
		lex_response += " " + lex_string
		
		# parse the phrase string by spaces so it can be turned into a PromptPhrase
		lex_phrase = lex_string.split(" ", true, 0)
		
		# create a PromptPhrase for this chunk
		lex_phrase_settings.push_back(PromptPhrase.new(rows, phrase_time, lex_phrase))
	
	# Now that all the PromptPhrases are done, we can create the actual prompt
	var lex_prompt = PromptSettings.new(convo_dict[JSONFields.PARTNERMESSAGETEXT], lex_phrase_settings)
	prompt_dict[JSONFields.REPUSHTIME] = convo_prompt_contents[ESA[JSONFields.REPUSHTIME]]
	prompt_dict[JSONFields.LEXMESSAGETEXT] = lex_response
	prompt_dict[JSONFields.PROMPTSETTINGS] = lex_prompt
	
	# Save out prompt to convo_dict
	convo_dict[JSONFields.PROMPTCONTENTS] = prompt_dict
	
	# Save index and return
	convo_dict[JSONFields.CONVERSATIONINDEX] = working_index
	working_index += 1
	
	return convo_dict
	
# The one time duck typing is useful! No need (or desire) to type this!
func parse_header_item(header_dict):
	if !header_dict:
		push_error("ConversationParser.parse_header_item: header_dict is null, JSON result is valid but empty!")
	
	conversation_partner = header_dict[ESA[JSONFields.CONVERSATIONPARTNER]]
	
func _get_conversation_parter() -> String:
	return conversation_partner

func get_next_conversation_chunck() -> Dictionary:
	# return an EOF conversation beat if the conversation is out of chunks
	if conversation_chunks.empty():
		return { JSONFields.TRIGGERSTORYBEAT : GameEnums.GameStoryBeat.EOF }
		
	return conversation_chunks.pop_front()

func get_conversation_subarray(convo_chunk_to_start_at : int) -> Array:
	var subarray_end = convo_chunk_to_start_at - 1
	
	if(subarray_end >= conversation_chunks.size()):
		push_error("ConversationEntryNode.get_conversation_subarray: subarray_end is too large, can't slice conversation_chunks")
		return []
	
	var array_front = conversation_chunks.slice(0, subarray_end)
	var array_back = conversation_chunks.slice(subarray_end + 1)
	conversation_chunks = array_back
	return array_front
