If the tier associated with a prompt expires while the slate is inactive the convo_dict index will be incremented, marking the prompt as pregenerated. Pregenerated parts of the convo _always_ become static text. This effectively skips the prompt.

How can we check for the game loading into a completed or uncompleted prompt?

Better yet, figure out a better way to handle the first-push timer timing out during inactivity. Currently, it just advances the index by 1.

My idea is this: instead of incrementing the index by 1, we can just directly tell the convo app slate that the timer went off already during pregeneration. It can then create the display requirements with the timer requirement already set to true. The GSB requirement will resolve to true automatically, so the message will display instantly!

So yeah, lets try that.