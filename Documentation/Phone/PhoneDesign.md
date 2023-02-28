Lex's phone does 3 things.

1. It manages the positioning of AppSlates
2. It condenses signals from AppSlates into one spot and either handles them or sends them upwards to the GameDaemon.
3. It navigates through AppSlates when its buttons are used.

Wait, what's a GameDaemon? The Game Manager. The node where I'm going to script out the story beats. The thing that runs the game scene. The 'check for completion' node. That kind of thing. I just got sick of calling it a Game Manager, you know? I never liked that name. I'm not going to implement it yet, but trust me it will exist.

Now, what is an AppSlate? GREAT QUESTION! An AppSlate represents both the visual appearance and the game state of the apps on Lex's phone. Because an app maintains state while it's not open, all of the AppSlates will probably be spawned when the game starts and/or be a native part of the PhoneControl scene. These individual Slates hold the gameplay elements and send the gameplay signals that make the story go. They each have their own unique navigable features and do their own unique things. They can also signal back to the PhoneControl to advance the story or send notifications:

The 5 + 1 AppSlates are:
1. Lex's Home Screen. The +1 of 5 + 1. Not actually an app, all it does is have buttons leading to all of the other apps on it and act as a landing zone if Lex presses the Home button.
2. iMessage. The hard one. Holds all of Lex's text conversations. May itself be split into a bunch of seperate AppSlates, one for each conversation, but I'm not sure yet. PromptControls for the phone can only be answered here. Entering it will show a list of contacts first. Lex will need to select an individual contact to answer the text messages.
3. Bank of America. Lex needs to go here to make sure their checking account has enough money to actually buy plane tickets. Will have a button to transfer the amount from one account to the other. Lex will press that button, choose (idk, savings?) to checking, then press OKAY to transfer. If scope becomes an issue, this is the AppSlate to cut.
4. Southwest Airlines. Lex needs to go here to buy plane tickets. Will have a simple select departure and select destination interface. Lex just needs to tap the 'departure' and 'destination' buttons to set the flight correctly. This one's tricky because (if I end up doing the bank), Lex's card will decline unless they've transferred money to their debit card
5. Distraction Apps. These apps are just here to take up space on the home screen and send annoying notifications to make the game harder. The plan is to have two of them. Cut if needed.

The PhoneControl also has 3 buttons on the bottom:
1. The Back Button will return to the previous AppSlate state if that makes sense (such as going from text message to contact in iMessage), undoing something (if that makes sense), or returning to the Home Screen (catch all). It's up to the AppSlate to decide what to do if the Back Button is pressed.
2. The Home Button instantly returns to the Home Screen, regardless of current AppSlate
3. The options button will have context-sensitive functionality. What is that functionality? idk, but it's up for the app slates to decide. Maybe resets the AppSlate state? Decide later.