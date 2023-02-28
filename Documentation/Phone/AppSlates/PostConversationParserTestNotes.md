Conversation Parsing is done now! This note doc is both notes from the testing process and a TODO as to what follow next.

TODO, in no order:
- Review the structure of the tester script, and use it as a base to make a rough design for the TextMessageAppSlate and its various parts.
- Read the response Lex sent you in the email about the questions you sent them.

Once all of this is done, parser is done! On to whatever git nonsense it is that you're doing!

Notes:
TextMessangerAppSlate will be responsible for a lot more formatting than I initially thought. Oh well!

You should probably put warning ignores above signal-related warnings in the various prompt and appslate scripts. You usually connect signals at runtime and rarely check the connection result, both of which causes warnings.