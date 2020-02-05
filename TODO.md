- [x] Fix Pig LOS
- [x] Remove any external links, visible .com web address or analytics tracking
- [x] Add our splash screen to the start of the game
- [x] Add our API integrations (see attached for more details)
- [x] Add a site lock (see instructions for the sites to lock it to)
- [x] Make sure the game fits within our iFrame which is a maximum of 800px wide and 600 px tall. 
- [x] Remove any full screen buttons or functionality
- [ ] Sprinting: It’s a bit too easy to sprint through the levels and win—please make the pigs react more quickly, or add a stamina bar for the sprint.
- [x] Progress saving when you close the browser tab/window
- [x] Wrong spelling: the word “hormones” was spelled as “horomones”—please change to “hormones”
- [x] Adult-themed Content: remove knife from pig sprite
- [x] Please email me if you did not receive our splash screen.
- [x] Please do NOT make our splash screen clickable.
- [x] Please set the page title of your index.html to “Game Name - Play it now at CoolmathGames.com”
- [x] Please optimize the file size of the game where possible.
- [x] We don’t need a “more games” button. If you have one, please remove it.
- [x] If you have a full screen button in your game, please remove that also.
- [x] If your game has a high score leaderboard where users enter their name/initials, please remove it.
- [x] Please have no stat counters or analytics in the game.
- [x] Also, please remove any external links, email addresses, website addresses, or twitter handles from the credits page (or any other page), if there are any.
- [x] Safari has added (and we expect Chrome will as well) a new option, enabled by default, that blocks audio from autoplaying elements on the page.
- [x] Update Tileset
- [ ] Remove local host from sitelock

## Notes

We have a custom JavaScript event system on our site which make sure that ad refreshes are triggered in between levels, rather than during gameplay, where it would negatively affect the user experience.
Here are the game events and JavaScript functions to add: 
For the PLAY button(s) that start a new game, call this JavaScript function, passing the word "start”:  cmgGameEvent("start");   Just to be clear, when the SWF loads there should not be a JavaScript call — instead it is only when a user clicks a PLAY button. If there is more than one PLAY button, then do the same thing for each PLAY button.
When the user starts a new level — for example, when they click a "LEVEL 1" button, or click a “CONTINUE” button to the next level — call this JavaScript function, passing the number or name of the level:  cmgGameEvent("start","1")    // where 1 is the level
When the user replays a level — for example, when they click RESTART or RELOAD, or TRY AGAIN — call this JavaScript function, passing the number or name of the level that is being replayed:  cmgGameEvent("replay","1")   // where 1 is the level
If the user does NOT press a button to replay a level (for example, if they fail and the level immediately restarts without them pressing anything) then do NOT call the JavaScript in this case. 
What is required is simply a call to the external JavaScript at the specified user events in the game that are outlined above. There is no need to handle a return value from this JavaScript call; there is no interesting return value passed back to ActionScript.

Please ensure that your game continues to function properly, even if cmgGameEvent is not present on the page.

HTML5 Notes

In JavaScript your game code will refer to the “parent”. See the next section here for more details on how to refer to the functions in the parent HTML document:

Because your HTML5 game code is running in an iframe, it is the parent HTML document that contains our JavaScript API function. The general approach to calling JavaScript from within an iframe is to use parent.myfunction().

Here are examples of each of the JavaScript API calls specified above, using parent:

The Play button: 
parent.cmgGameEvent(“start”);

Starting a level
parent.cmgGameEvent("start","1")    // where 1 is the level

Replaying a level
parent.cmgGameEvent(“replay","1”)   // where 1 is the level
