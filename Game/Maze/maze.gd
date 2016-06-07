#Based on python code by d.factorial [at] gmail.com
tool
extends Node

#the dimensions of the maze
export var xwide = 100
export var yhigh = 100

# numbre of rooms
export var n_rooms = 5
#parameter branchrate:
    #zero is unbiased, positive will make branches more frequent, negative will cause long passages
    #this controls the position in the list chosen: positive makes the start of the list more likely,
    #negative makes the end of the list more likely
    #large negative values make the original point obvious
    #try values between -10, 10
export var branchrate = 0




#the grid of the maze
#each cell of the maze is one of the following:
    # 0 is wall
    # 1 is corridor floor
    # 2 is room floor
    # 3 is decoration
    # 4 is border

    # -1 is exposed but undetermined
    # -2 is unexposed and undetermined
var field = []

#list of coordinates of exposed but undetermined cells.
var frontier = []

const E = 2.71828182846


func _ready():
	#randomize()
	seed(13)
	init()	
	make_maze()
	#print_maze(field)
	update_tilemap(field)

func shuffleArray(a):
	for i in range (0,a.size()-2):
		var j =  i + randi()%(a.size() - i)
		var tmp = a[i]
		a[i] = a[j]
		a[j] = tmp
	return a
		
	
func init():
	for y in range(yhigh):
		var row = []
		for x in range(xwide):
        	row.append(-2)
		field.append(row)

func carve(y, x):
    #Make the cell at y,x a space.
    #Update the frontier and field accordingly.
    #Note: this does not remove the current cell from frontier, it only adds new cells.
    
	var extra = []
	field[y][x] = 1
	if x > 0:
		if field[y][x-1] == -2:
			field[y][x-1] = -1
			extra.append(Vector2(y,x-1))
	if x < xwide - 1:
		if field[y][x+1] == -2:
			field[y][x+1] = -1
			extra.append(Vector2(y,x+1))
	if y > 0:
		if field[y-1][x] == -2:
			field[y-1][x] = -1
			extra.append(Vector2(y-1,x))
	if y < yhigh - 1:
		if field[y+1][x] == -2:
			field[y+1][x] = -1
			extra.append(Vector2(y+1,x))
	shuffleArray(extra)
	frontier = frontier + extra

func harden(y, x):
	#Make the cell at y,x a wall.
    field[y][x] = 0

func check(y, x, nodiagonals = true):
    #Test the cell at y,x: can this cell become a space?
    #True indicates it should become a space,
    #False indicates it should become a wall.
    
    var edgestate = 0
    if x > 0:
        if field[y][x-1] == 1:
            edgestate += 1
    if x < xwide-1:
        if field[y][x+1] == 1:
            edgestate += 2
    if y > 0:
        if field[y-1][x] == 1:
            edgestate += 4
    if y < yhigh-1:
        if field[y+1][x] == 1:
            edgestate += 8

    if nodiagonals:
        #if this would make a diagonal connecition, forbid it
            #the following steps make the test a bit more complicated and are not necessary,
            #but without them the mazes don't look as good
        if edgestate == 1:
            if x < xwide-1:
                if y > 0:
                    if field[y-1][x+1] == 1:
                        return false
                if y < yhigh-1:
                    if field[y+1][x+1] == 1:
                        return false
            return true
        elif edgestate == 2:
            if x > 0:
                if y > 0:
                    if field[y-1][x-1] == 1:
                        return false
                if y < yhigh-1:
                    if field[y+1][x-1] == 1:
                        return false
            return true
        elif edgestate == 4:
            if y < yhigh-1:
                if x > 0:
                    if field[y+1][x-1] == 1:
                        return false
                if x < xwide-1:
                    if field[y+1][x+1] == 1:
                        return false
            return true
        elif edgestate == 8:
            if y > 0:
                if x > 0:
                    if field[y-1][x-1] == 1:
                        return false
                if x < xwide-1:
                    if field[y-1][x+1] == 1:
                        return false
            return true
        return false
    else:
        #diagonal walls are permitted
        if  [1,2,4,8].find(edgestate) != -1:
            return true
        return false

func make_rooms(n_rooms, min_size, max_size):
	var max_tries = n_rooms * 3
	var room_list = []
	var n_rooms_made = 0
	
	for t in range(0, max_tries):
	
		if n_rooms_made > n_rooms:
			break

		# define posible rooms
		var w_room = min_size + randi()%(max_size - min_size)
		var h_room = min_size + randi()%(max_size - min_size)
		var x_room = 2 + randi()%(xwide - 1 - w_room - 2)
		var y_room = 2 + randi()%(yhigh - 1 - h_room - 2)
		
		# check for collsions with other rooms
		if room_list.size() == 0:
			room_list.append([x_room, y_room, w_room, h_room])
			n_rooms_made += 1
		else:
			#compute intersection between new_room and previous 
			var area_i = 0
			for r in room_list:
				area_i += max(0, min(r[0]+r[2],x_room+w_room) - max(r[0], x_room)) \
				 * max(0, min(r[1]+r[3], y_room+h_room) - max(r[1], y_room))

			if area_i == 0: # no collisions
			 	room_list.append([x_room, y_room, w_room, h_room])	 
			 	n_rooms_made += 1

			 	#make room:
			 	for x in range (x_room, x_room + w_room):
			 		for y in range (y_room, y_room + h_room):
			 			field[y][x] = 2

func make_maze():
	#choose a original point at random and carve it out.
	var xchoice = randi()%(xwide-1)
	var ychoice = randi()%(yhigh-1)
	carve(ychoice,xchoice)
	
	while(frontier.size()):
		#select a random edge
		var pos = randf()
		pos = pow(pos,pow(E,-branchrate))
		var choice = frontier[int(pos*frontier.size())]
		if check(choice.x, choice.y):
			carve(choice.x, choice.y)
		else:
			harden(choice.x, choice.y)
		
		frontier.erase(choice)

	#set unexposed cells to be walls
	for y in range(0,yhigh):
		for x in range(0,xwide):
			if field[y][x] == -2:
				field[y][x] = 0

	# make rooms in maze
	make_rooms(n_rooms, int(min(xwide, yhigh)*0.1), int(min(xwide, yhigh)*0.2))

func print_maze(maze, data = false):
	print ("Maze:")
	if data:
		var line_str =""
		for i in range (0,xwide):
			for j in range(0,yhigh):
				line_str += str(maze[i][j])+ " "
			print (line_str)
			line_str = ""
	else:
		var line_str =""
		for i in range (0,xwide):
			line_str += "_"
		print (line_str)
		line_str=""
		for i in range (0,xwide):
			line_str="|"
			for j in range(0,yhigh):
				if maze[i][j] == 0:
					line_str += "0"
				else:
					line_str += "1"
			line_str+="|"
			print (line_str)
			line_str = ""
		for i in range (0,xwide):
			line_str += "_"
		print (line_str)
		line_str=""

func update_tilemap(maze):
	var tilemap = get_node("TileMap")
	for i in range (0,xwide):
		for j in range(0,yhigh):
			if field[i][j] == 0:
				tilemap.set_cell(i,j,0)
			else:
				tilemap.set_cell(i,j,-1)
	

