While the inner core of gameplay is done with the Prompt, the outer layer of game flow is handled across three seperate objects: AppSlates, the PhoneControl, and the GameDaemon. This document gives a brief outline of what these objects all do, followed by how they worked together.

## Individual Objects

### AppSlate
Each 'app' on Lex's phone is represented by a control that derives from AppSlate. What each derived appslate does and how each derived appslate is laid out is child-specific (and isn't covered here), but the AppSlate baseclass they all share handle general interactions with the phone.

An AppSlate's primary purpose is to interface with the PhoneControl by sending signals (GameStoryBeats occuring, notifications, requests to change appslates) and receiving signals (home button presses, back button presses, option button presses).

### PhoneControl
Lex's phone is represented, both visually and in gameplay, by the PhoneControl. The phone control places and arranges AppSlates, and has buttons (Home, Back, Options) that the player can use for AppSlate-agnostic navigation. 


The PhoneControl's primary purpose is to send navigation signals to AppSlates (home, back, options) and to receive signals from AppSlates (change appslate, GameStoryBeat occured, and notification). PhoneControl also implements responses to the signals it receives: it processes appslate changes, pushes notification visuals/text onto the phone screen, and passes GameStoryBeat signals along to the GameDaemon

### GameDaemon
Also known as GameDaemonNode, the GameDaemon can be understood as a Game/LevelManager. The GameDaemon implements the progression of the game by expecting and reacting to certain GameStoryBeats in order. How it does this hasn't been implemented yet, but it will probably be a simple list of GameStoryBeats to iterate through in order.

The GameDaemon's primary purpose is to receive GameStoryBeat signals from the PhoneControl to decide if the game should progress. In addition to any other consequences of a GameStoryBeat (which I haven't decided on yet), the GameDaemon forces the Messaging AppSlate to send text messages when the story needs them. This is the only time the GameDaemon interacts directly with an AppSlate, and it is only done through a direct reference from the PhoneControl's AppSlate dictionary. I'd think of a better way to couple them together, but it really didn't seem necessary to make a bridge object or something like that.

## How They Work Together

The player interacts with the game by clicking on AppSlates. Certain objects can cause the AppSlates to change or to advance the game by sending a GameStoryBeat. The PhoneControl evaluates these signals from the AppSlates, either by undertaking some action (pushing a notification to the Phone's screen or changing an appslate) or passing it on to the GameDaemon (GameStoryBeat). If causing a GameStoryBeat should cause something to happen, the GameDaemon commissions that result. This usually takes the form of the GameDaemon changing which GameStoryBeat it expects, but might include other actions, such as forcing certain text messages or ending the game.