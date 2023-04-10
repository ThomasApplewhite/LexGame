GameDaemon needs to do two things right now to properly function:

1: Manage a list of GameStoryBeats and the order they are in
2: Send signals when certain GameStoryBeats are triggered to cause certain game events to happen
3: Receive signals to advance the list of GameStoryBeats

Okay haha that's 3 things but whatever.

Thankfully, there's only 3 things the GameDaemon needs to do when reacting to a story beat:

1. Decide if the received GSB is the Anticipated GSB
2. Advance to the next GSB if it is
3. Send Text Messages when certain story beats become active
4. Check if Lex has bought her flight when certain story beats become active

Okay, that's 4, but the first two are both simple and happen regularly, so no sweat there. It's thing 3 and 4 that will take measurable effort.

I also need a way to save out orderings of these things into some sort of asset.

So, lets do it like this:
0. Declare the concept of the GameStoryBeat. This may already exist in GameEnums. --DONE--
1. Write a GSB comparison algorithm, and add a slot to contain the anticipated/desired/thing that we are waiting for so we can advance/Required! GSB. --DONE--
2. Create the GSB storage asset --DONE--
3. Write an algo to get the next GSB from the asset -DONE--
4. Text Message sending
5. Flight checking

Yup. Lets go!

