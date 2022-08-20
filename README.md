# Sea Mayem

Sea Mayem is an arcade multiplayer game developded as an hobby project with the goal of being a learning environment for myself. It uses concepts like socket and server programming, UI desing, game design etc. The client application uses Java with the Processing API and the sever application is written in Python.

## The Game

Sea Mayem is a multiplayer arcade battleship war game, in which each player is able to build his/her own warship and battle against other players in a naval map. The game is all 2D and most mechanics are based on creating a counter strategy relative to your opponents, team work and luck.

## Game description in detail

Sea mayem starts in the main screen, where the player is able to select the server's ip and port and set a name. If a player tries to connect to a server, the client application will attempt to create a socket connection. If successfull, the client will send a login message with information like the player name and the server will reply with a message containing information like the size of the game map or the maximum number of points usable for attack parts on boats.

![Main menu screenshot](https://i.imgur.com/oYU0JKB.png)
