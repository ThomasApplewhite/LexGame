Prompt Signal Flow

0: A button gets clicked

1: button informs VBox (signal)

2: VBox tells control if button was correct or not (signal)

3: Control interprets VBox information and does one of the following:

A: If the button is correct and it was the last one in the phrase, move on to the next phrase (or finish if there are no phrases left)
B: If the button is correct and it wasn't the last one in the phrase, do nothing
C: If the button is incorrect, fail the phrase and return to the previous one (or return to the start of this phrase if there is no 'previous' phrase)

4: A Prompt is closed if the UI Thing that it's on gets closed (for example, Lex taps to a different app while texting somebody) or if the phrase is totally completed.