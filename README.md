# Sea Mayem

Sea Mayem is an arcade multiplayer game developded as an hobby project with the goal of being a learning environment for myself. It uses concepts like socket and server programming, UI desing, game design etc. The client application uses Java with the Processing API and the sever application is written in Python.

## The Game

Sea Mayem is a multiplayer arcade battleship war game, in which each player is able to build his/her own warship and battle against other players in a naval map. The game is all 2D and most mechanics are based on creating a counter strategy relative to your opponents, team work and luck.

## Game description in detail

Sea mayem starts in the main screen, where the player is able to select the server's ip and port and set a name. If a player tries to connect to a server, the client application will attempt to create a socket connection. If successfull, the client will send a login message with information like the player name and the server will reply with a message containing information like the size of the game map or the maximum number of points usable for attack parts on boats.

![Main menu screenshot](https://i.imgur.com/oYU0JKB.png)

Then the server sends the current teams information and presents it on a new menu, where the player can view the teams, swap teams, and hit the ready button.

![Teams menu screenshot](https://i.imgur.com/HgqP4ms.png)

Once every player declared themselves ready, the server would command all clients to go to the building menu, where each player is able to build his/her own ship, by selecting its components. Each component as a cost (either 5, 10 or 15 points) and there is a maximum number of points a player can use to build his/her boat, so the player can specialize the ship in the way he/she prefers. This also means proper team communication could allow each player to specialize in a different aspect and have a team with variety of functions. The player can also see his/her team, the current points allocated to each function in his/her ship relative to the maximum possible and set a name for the ship.

![Teams menu screenshot](https://i.imgur.com/wC1y2Qy.png)

The player can also use a part of the total points, called the special points, to spy on the enemy team, meaning he/she can have some information of the enemy team's current setup. The enemy team can however change the setup after an espionage attempt, therefore this mechanic has to be used with caution. 

![Teams menu screenshot](https://i.imgur.com/48zGMEN.png)

Once all players are ready, the server commands all players to go to a loading screen and sends the map, generated when the server was created, to all players. Then it sets all boats positions in the map, generates boats for bots if necessary and when the game setup is all done it checks wether all player have confirmed the correct reception of the map. If so the server tells all clients to start the game. The client side in turn, from this point on, will repeatedly send request for game information and the server will continuously respond with the information regarding all gama data, such as boat positions, boat bearings, projectile positions, etc.

At this stage the player is first presented with the Map Screen, in wich the player is able to see the whole map, his/her position and also the position of other teammates. There is also a radar, placed in the players position, that is able to detect enemies and enemy's projectiles. This detection is done by sweeping the radar, and if the radar hits an enemy or a projectile a dot, of red or orange color respectively, is drawn on the map. Furthermore, the player can select a coordinate and press the fire button that fires one of his/her attack turrets and that sends a projectile of the apropriate type to those coordinatews. 

![Teams menu screenshot](https://i.imgur.com/L5cnjvL.png)

There is a cooldown mechanic to prevent players from spaamming the fire button. The back button leads to the Command Screen, where the player can change the speed of the boat, steer it or even drop an anchor, altough this screen is not yet implemented.

## Further notes on the server

Once the server is launched, it start by generating a map according to the size that is set in code (altough in the future it should only generate it once the user specifies the size) using perlin noise, then it sets every point below a certain altitude to '-1' (meaning it is sea) and every point above to a range between 0 and 99.

The server has a simple console that allows adding bots, seeing the team, asking for the server to restart, etc.

## The UI Library

The UI Library (UILib.pde) is library developed alongside the project with the purpose of also being suitable for integration in other projects. It implements UI elements such as buttons, text boxes, scroll lists, progress bars, etc. Every element is graphically customizable, for instance, you can set the color of a button when it is idle, when someone is clicking it, or when it is disabled.

## Future progress and features

The first playable version of the game is not yet available, altough only the command screen and ending screen are not implemented and some bugs are not fixed.

Some features that are yet to be implemented are:
* Enhancing enemy projectile drawing
* Increase game performance and, consequently, FPS
* Create a bether server console
* Port the game for Android
* Implement tides and wind in the game to steer ships away from current trajectory
* Implement viewing your team setup in the building menu, or at least a simplified version of that
