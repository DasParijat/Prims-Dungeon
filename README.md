Topic: Connections

Idea - Prim's Dungeon
Description: 
	Prim's Dungeon is based off Prim's Algo of finding the MST of a graph. However instead of
	a graph, it is a dungeon, with each node being a room, and each door representing an edge with
	a weight. 
	
	An MST (Minimum-Spanning tree) of a graph is a graph with the same nodes, but with the lowest
	total cost of edges (aka, redundant edges are removed in the MST version). In relation to the
	topic, it means finding a way to keep all rooms/nodes "connected" while getting the smallest
	number of total weight possible.
	
	The goal of the game is for the player to get all orbs (one in each room) in order to escape
	or whatever. Meaning they must have explored every room in the dungeon
	
	The way the game works is that each door (a connection between two rooms) has a cost, which
	the player pays for via points they get at the start. The points they get at the start is
	the same as the total weight of the MST version of the graph/dungeon they play in, AKA,
	player's are forced to follow Prim's Algo in order to win.
	
Objects:
	Game:
		-Starting room is randomized (any room), but it must be kept track of once chosen (for resetting)
		-Display points and rooms visited (visited / total rooms) at top right
		-Display page on top right, which when clicked, gives player basic idea of what to do
		-Esc button/ Pause button bottom left, which allows user to reset level 
		(dungeon same, but they start over from the starting room)
		-If user tries buying a door, and it results 
		in them having points <= 0 (check this before room transition),
		then give game over screen.
		-Game over screen has button to reset game 
		
	Dungeon/Graph Generation (Hard):
		-Try making a default pre-made graph as test for game
		-Generate a random number of rooms (Min is 3, max is 26, default is 10)
		-Generate random edges
			-Go to each room and give them an edge to any other room (randomly)
				-1st Loop: Go through each room and give them one edge to the next room (A -> B)
							(1st loop makes sure all rooms are connected in the first place)
				-2nd Loop: Go through each room and give them 0-2 edges to random rooms (A -> Random)
							(2nd loop creates extra edges that add randomness to generation)
			-If they randomly generate an edge that already exists, disregard that (if edge in edges, return)
		-Use Prim's Algo to calculate the total weight of the MST of the randomly generated graph
			-The result will be the starting points the player has
		-Randomly choose which room is the starting room
			
	Room/Node: 
		-{letter = A, orb_found : bool = false, mod_color = Color()}
		-Each room has a letter id (A, B, C)
		-Each room has an orb (Once player visits room, orb is taken)
			-Orb also serves as reminder if player has visited room or not
		-OPTIONAL Each room has a unique modulate color value (to make it easier to see the difference)
	
	Room Transition:
		-A single base room is used for all rooms
		-When going from Room A to Room B, Room A tweens to fade to black and go bigger
		-Then the base room changes property of room from A to B
			-Get rid of doors and add Room B's doors
			-Change modulate color of room
			-Add orb if room B was undiscovered
		-Then tween Room B (base room) to go smaller and fade back in
		-For doors, when room is in transition, they are unclickable
		-Doors are managed seperately from room
			-On each transition, a VBOX generates the correct doors based on what room it's transitioning in
			-For Room B, it checks through all edges for edges that contain B, then add it as a door
			-Loop this check four times (with 4 being the max number of doors in a room)
		
	Door/Edge:
		-{Room 1 = Room(), Room 2 = Room(), Weight/Cost : int, is_locked : bool}
		-Door properties:
			-{Room A, Room B, Weight/Cost, lock status}
		-Door recognizes what room it is currently in
			-Ex. If {A, B} door is in room A, opening it will take player to room B, and vice versa
		-Once door is unlocked, it remains open the rest of the game
		-Going from room A to room B, room B has a door to Room A, 
		thus once player visits room B, door {A, B} should already be opened
		-Thus lock status indicates whether that door is locked or not, for any room
		
