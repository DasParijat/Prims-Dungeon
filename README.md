# Prim's Dungeon
This was a Godot 4.3 game that was made for the Marist Game Developer Club's Hackathon in Spring 2025, that is now being expanded on. The original Game Jam repo can be found in my profile.

# Play through this link!
dasparijat.github.io/Prims-Dungeon/

## Description: 
-	Prim's Dungeon is based off Prim's Algo of finding the MST of a graph. However instead of
	a graph, it is a dungeon, with each node being a room, and each door representing an edge with
	a weight. 
	
-	An MST (Minimum-Spanning tree) of a graph is a graph with the same nodes, but with the lowest
	total cost of edges (aka, redundant edges are removed in the MST version). In relation to the
	topic, it means finding a way to keep all rooms/nodes "connected" while getting the smallest
	number of total weight possible.
	
-	The goal of the game is for the player to get all orbs (one in each room) in order to win the game Meaning they must have explored every room in the dungeon
	
-	The way the game works is that each door (a connection between two rooms) has a cost, which
	the player pays for via points they get at the start. The points they get at the start is
	the same as the total weight of the MST version of the graph/dungeon they play in.

-	Due to how the game is placed, players are forced to follow Prim's Algorithm in order to win, which in turn educates them on how the algorithm works.

## Project Description:

### docs folder:
- The "docs" folder holds the playable HTML version of the game
- It's named docs to allow Github Pages to run it

### Home Menu:
- Allow player to set the number of rooms of the dungeon via a slider

### Game:
- Starting room is randomized (any room), but it must be kept track of once chosen (for resetting)
- Display points and rooms visited (visited / total rooms) at top left
- Display pause menu on top right, which when clicked, expands the menu to show buttons to
	- Reset the current level (Same dungeon but back at the start)
	- Go back to the previously visited room
		- Keep track of previous rooms player was in
		- Cap the number of rooms remembered to 25
		- Clear previous rooms upon starting game scene again to prevent it remembering rooms from the old dungeon.
	- Go back to the menu
		
### Dungeon/Graph Generation (Hard):
- Generate a gicen number of rooms (Min is 5, max is 25, default is 10)
- Generate random edges
	- Go to each room and give them an edge to any other room (randomly)
	- 1st Loop: Go through each room and give them edges to random rooms (A -> Random)
		- (2nd loop creates extra edges that add randomness to generation)
	- 2nd Loop: Go through each room and give them one edge to the next room (A -> B)
		- (1st loop makes sure all rooms are connected in the first place)
	- If they randomly generate an edge that already exists, disregard that (if edge in edges, return)
	- Use Prim's Algo to calculate the total weight of the MST of the randomly generated graph
		- The result will be the starting points the player has
			
### Room/Node: 
- {letter = A, orb_found : bool = false, mod_color = Color()}
- Each room has a letter id (A, B, C)
- Each room has an orb (Once player visits room, orb is taken)
	- Orb also serves as reminder if player has visited room or not
- Each room has a unique modulate color value (to make it easier to see the difference between rooms)
	
### Room Transition:
- A single base room is used for all rooms
- When going from Room A to Room B, Room A tweens to fade to black and go bigger
- Then the base room changes property of room from A to B
	- Get rid of doors and add Room B's doors
	- Change modulate color of room
	- Add orb if room B was undiscovered
- Doors are managed seperately from room
	- On each transition, a VBOX generates the correct doors based on what room it's transitioning in
	- For Room B, it checks through all edges for edges that contain B, then add it as a door
		
### Door/Edge:
- {Room 1 = Room(), Room 2 = Room(), Weight/Cost : int, is_locked : bool}
- Door properties:
	- {Room A, Room B, Weight/Cost, lock status}
- Door recognizes what room it is currently in
	- Ex. If {A, B} door is in room A, opening it will take player to room B, and vice versa
- Once door is unlocked, it remains open the rest of the game
- Going from room A to room B, room B has a door to Room A, 
thus once player visits room B, door {A, B} should already be opened
- Thus lock status indicates whether that door is locked or not, for any room
- Doors will have a red glow underneath if they lead back to an already orbless room (AKA an already visited room).

		
