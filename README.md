# Space Gravity

Space Gravity is a game about flying a space ship. The controls are simple: the ship will fly to wherever the player touches. He must be aware of the laws of physics and the fuel level of the ship at all times. There are two game modes: Classic and Adventure. The game is written in Swift, uses the SpriteKit framework, and uses the CloudKit and GameKit frameworks to save data to iCloud and report scores to the leaderboard.

#### Classic Mode
In classic mode, asteroids fly in from off screen. The objective is to avoid the asteroids for as long as possible. The longer the player survives, the higher the score.

#### Adventure Mode [In Development]
Adventure Mode takes place as a series of levels. The objective is to fly the ship to the goal. There are a variety of obstacles to overcome to make it to each goal.

---

## Known Issues
There is an issue with audio right now. It works, but runtime warnings are printed in the console. It is also taking a long time to load levels in Adventure Mode with a lot of game elements in them. Again, everything is completely functional, but loading levels will need optimization.

---

## Contributing to Adventure Mode
Adventure Mode is currently incomplete. However, most of the work is done to allow for easy level creation. Simply create a new level in the levels folder with the format `LevelX.sks` and set `Custom Class` to `AdventureModeScene`, and the game will load that level file when tapped in the level select scene. Optionally, a transition message can be created in `TransitionMessages.plist`, with the key set to the appropriate level.

Crafting a level is done entirely within the Xcode scene editor. Note that the space ship will spawn at the origin. Objects can be added by dragging color sprites into the scene and setting the name. The image associated with the sprite does not have to be set; as long as the sprite is named, everything will be set up appropriately. There are, however, some options that can be set for certain objects. Sprites for some of these game elements have not been made yet. Until they are made and implemented, some sprites may appear as solid-colored boxes.

#### Game Elements

###### Asteroids
Asteroids are stationary objects in Adventure Mode. They will cause a game over if the ship crashes into it. The only property that can be set for asteroids is the position. Drag and drop the node where it needs to go and set the name to `asteroid`.

###### Goal
There can only be one goal in each level. Once the player reaches the goal, the level is completed and the scene transitions. The only property that can be set for the goal is the position. Drag and drop the node where it needs to go and set the name to `goal`.

###### Walls
Walls are stationary objects that react with ships exaclty the same way asteroids do. In addition to setting a position, walls can be made any size. Drag and drop the node where it needs to go, resize it, and set the name to `wall`.

###### Switches
A switch does not affect the way the ship flies in any way. Once the switch is activated, anything on the same channel is interacted with. After a set duration, the switch deactivates, and so does everything on the same channel. The channel cannot be set at this time; that is a feature in progress. Right now, the only object that can be affected by the switch are doors. Drag and drop the node where it needs to go, set the duration under User Data by setting the name to `duration` and setting the value to an integer, and set the name to `switch`.

###### Doors
Doors function exactly like walls, with the difference being that they can be opened and closed with a switch. Similar to switches, they are activated by any switch on the same channel. Drag and drop the node where it needs to go, set the channel under User Data by setting the name to `channel` and setting the value to an integer, and set the name to `door`.

###### Stardust
Stardust are collectable items that can be collected. They can be thought of similar to coins in Mario games. To make best use of these, place them where it would be a challenge to reach or where they can be a guide to the player for a direction. The position is the only property that can be set. Drag and drop the node where it needs to go and set the name to `stardust`.

###### Wormholes
A wormhole is a portal which moves the ship to the another corrosponding wormhole. Each wormhole has an `id` and a `destinationID`. If the ship is flown into a wormhole, it will teleport the ship to the wormhole whose `id` is that wormhole's `destinationID`. Drag and drop the node where it needs to go, set the `id` and `destinationID` under User Data, and set the name to `wormhole`.

###### Aliens
An alien will follow the ship wherever it goes at a defined set speed. If no speed is set, they similar to walls. The position and speed of the alien are the available properties to be set. Drag and drop the node where it needs to go, set the speed under User Data by setting the name to `speed` and setting the value to a float, and set the name to `alien`.

###### Slaloms
Slaloms are narrow passes that are designed to require precise flying to pass through. If the ship flies into the bounderies, it is game over. This is an experimental game element; they do nothing special right now. The width of the slalom is planned to be added. The only properties that can be set right now are the position and the rotation. Drag and drop the node where it needs to go, rotate it, and set the name to `slalom`.

---

Space Gravity was developed by Bison Software in 2014. This version was developed as a remaster of that game by adding better art and graphics, new sounds, cleaner code, and the new Adventure Mode [in development].
