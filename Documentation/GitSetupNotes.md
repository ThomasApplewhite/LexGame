To get Git going, I need Git both on my laptop and my computer, AND some sort of VPN client to connect them. And then I also need to figure out how to link the two over VPN.

- Git is easy. It can be installed from terminal without much fuss.
- I need to decide on a VPN. It can be pretty simple, since right now I never need to do anything other than LAN
- Connecting the two git instances will take a little bit of thought, especially getting it worked out with the VPN. That will come last.

None of the above is true lol. As long as the two machines are on the same network you can ssh from one to the other with something like [username]@[ip]:[path to .git from root]. Just keep in mind that one machine being on wire and the other being on wifi doesn't count for this.