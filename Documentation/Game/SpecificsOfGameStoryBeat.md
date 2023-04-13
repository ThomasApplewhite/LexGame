There's a little bit of undecidedness/ambiguity with how the GameStoryBeat works, and what exactly it's for. This is mostly because I never deisnged them to do anything, I just needed the stub at the time. But here's how they'll actually work.

The GameDaemon receives a GameStoryBeatList from the inspector. Each GameStoryBeat (except the last) will send a signal containing the next anticipated GameStoryBeat to the phone. The first signal will be sent  automatically on game start, and the last GameStoryBeat will transitio to the end game instead.

Imagine it as a back-and-forth. The GameDaemon asks the phone to produce a GSB and when the phoe is ready, it does.

Two questions:
1. How do we handle parts of the story that can happen out of order?
2. How do we handle parts of the story that recieve GSBs but cant occur yet because other parts of the same dialogue script have't happened yet? 

The answer to both can probably be frequency checks. When a convo chunk that needs a GSB hits, it can check if the correct number of GSBs have already arrived. If they have, continue! If not, it will need to wait for a signal to tell it that is has recieved the correct number.
Maybe the entries should be resposible for this. The GameDaemo tells the text appslate whe a GSB updates, ad the the text message slate tells all the entries, and then the entries figure it out from there.

Basically, on new chunk:
is somehow??? figure out if signal is met with needed frequency
yes? continue
no? subscribe to new gsb signal. listen until the gsb and frequency desired match. Once it is so, stop listening and continue.

Two notes to self:
1. Refactor the GameStoyBeat (or extend it) to include those hints you want to put at the bottom of the screen.
2. Refacor the covneration stuff not have a partner text spot if there is not supposed to be a parter message along with a prompt.
