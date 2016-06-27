
extends Area2D

var life = 500
var currentLife = life
var text = "Destroy the Enemy Nexus"
onready var root_node = get_node("/root/TestLevel")
var maze_size = null
var maze_tilemap = null

var radius = 0

func _ready():
	randomize()
	var timeout = randi()%100 + 60
	get_node("Timer").set_wait_time(timeout)
	get_node("Timer").start()
	root_node.get_node("ui/bottom/LabelA").set_text(text)
	maze_size = get_node("/root/configFileManager").getMazeSize()
	maze_tilemap = get_node("/root/TestLevel/Maze/Navigation2D/TileMap")
	
	# place 
	for i in range (0,100): #try a hundred times
		var pos_x = randi()%(maze_size * 4 * 64) #maze:size * scale* tile_size
		var pos_y = randi()%(maze_size * 4 * 64)
		var tile_pos = maze_tilemap.world_to_map(Vector2(pos_x, pos_y)*1.0/maze_tilemap.get_scale().x)
		tile_pos = Vector2(floor(tile_pos.x), floor(tile_pos.y))
		if maze_tilemap.get_cellv(tile_pos) == 0:
			set_pos(Vector2(pos_x, pos_y))
			break
	
	set_process(true)

func _process(delta):

	radius += 800 * delta
	if radius >= (maze_size * 4 * 64):
		radius = 0
	update()
	
	var time = get_node("Timer").get_time_left()
	root_node.get_node("ui/bottom/time").set_text(str(floor(time)))
	
func add_life(lifeValue):
	
	currentLife += lifeValue
	print (currentLife)
	if currentLife <= 0:
		root_node.objectives_cleared += 1
		root_node.get_node("ui/top/Level").set_text("Missions = "+str(root_node.objectives_cleared ))
		get_node("Particles2D").set_emitting(true)
		get_node("timer_destroy").start()
		set_process(false)
		set_monitorable(false)

		get_node("Sprite").hide()


func _draw():
	draw_rect(Rect2(45,45,170, 50),  Color(0.871, 0.808, 0.612))
	draw_rect(Rect2(50,50,160.0*currentLife/life, 40),  Color(0.635, 0.071, 0.196))
		
	var center = Vector2(0,0)
	var angle_from = 0
	var angle_to = 355
	var color =  Color(0.635, 0.071, 0.196)
	draw_circle_arc( center, radius, angle_from, angle_to, color )
	var radius2 = radius - radius / 2
	if radius2 > 0:
		draw_circle_arc( center, radius2, angle_from, angle_to, color )


func draw_circle_arc( center, radius, angle_from, angle_to, color ):
    var nb_points = 32
    var points_arc = Vector2Array()

    for i in range(nb_points+1):
        var angle_point = angle_from + i*(angle_to-angle_from)/nb_points - 90
        var point = center + Vector2( cos(deg2rad(angle_point)), sin(deg2rad(angle_point)) ) * radius
        points_arc.push_back( point )

    for indexPoint in range(nb_points):
        draw_line(points_arc[indexPoint], points_arc[indexPoint+1], color, 4)

func _on_timer_destroy_timeout():
	get_node("Particles2D").set_emitting(false)
	root_node.add_mission()
	queue_free()


func _on_Timer_timeout():
	root_node.get_node("ui/bottom/LabelA").set_text("Timeout: Mission Failed")
	root_node.get_node("Human Player").lives -= 1
	root_node.get_node("ui/top/lives").set_text(str(root_node.get_node("Human Player").lives))
	get_node("Particles2D").set_emitting(true)
	get_node("timer_destroy").start()
	set_process(false)
	set_monitorable(false)
	get_node("Sprite").hide()
