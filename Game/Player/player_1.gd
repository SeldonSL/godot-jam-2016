# Keyboard + mouse player
extends KinematicBody2D

# Actions
export var speed = 3 # player speed
export var life = 200 # player life
var isShooting = false
var shootAngle = 0
var last_angle = Vector2(0,0)
var mousePos = Vector2(0,0)
var currentLife = life
var weapon_level = 1
var lives = 3

var weapon_1 = preload("res://Game/Weapons/weapon_1.tscn")
var weapon_2 = preload("res://Game/Weapons/weapon_2.tscn")
var weapon_3 = preload("res://Game/Weapons/weapon_3.tscn")
var weapon_4 = preload("res://Game/Weapons/weapon_4.tscn")
onready var sound = get_node("/root/menu_music/SamplePlayer")

var is_dead = false
var has_shield = false
var shield_damage = 0

# Keyboard Movement actions
var move_actions = { "K_MOVE_LEFT":Vector2(-1,0), "K_MOVE_RIGHT":Vector2(1,0), "K_MOVE_UP":Vector2(0,-1), "K_MOVE_DOWN":Vector2(0,1) }

var path = []
var maze_size = null
var maze_tilemap = null

var dir = Vector2(0,0)
var dir_slide = Vector2(0,0)



func _ready():
	set_process(true)
	set_process_input(true)
	get_node("/root/TestLevel/ui/top/Life").set_value(currentLife)
	get_node("/root/TestLevel/ui/top/Life").set_max(life)
	get_node("/root/TestLevel/ui/top/lives").set_text(str(lives))
	maze_size = get_node("/root/configFileManager").getMazeSize()
	maze_tilemap = get_node("/root/TestLevel/Maze/Navigation2D/TileMap")
	
func _process(delta):	
	
	if lives <= 0:
		print ("DEAD: Game Over")
		
	# Movement
	#dir = Vector2(0,0)
	#make character slide nicely through the world	
	var slides_attemps = 5
	if(is_colliding() and slides_attemps > 0):
		dir = get_collision_normal().slide(dir)
		dir = move(dir.normalized()*speed*delta*0.5)
		slides_attemps -= 1
	else:
		dir = Vector2(0,0)
	
	
	
	for ac in move_actions:
		if Input.is_action_pressed(ac):
			dir += move_actions[ac]
			
	move(dir.normalized() * speed * delta)
	if dir == Vector2(0,0):
		#look_at(last_angle)

		var rot = Vector2(0,0).angle_to_point(last_angle)-3.14159
		set_rot(rot )
	#elif is_colliding():
	#	var rot = Vector2(0,0).angle_to_point(last_angle)-3.14159 
	#	set_rot( rot )
	else:
		last_angle = dir
		var rot = Vector2(0,0).angle_to_point(last_angle)-3.14159
		set_rot(rot )
	

	
	# Shooting
	if Input.is_action_pressed("M_SHOOT"):
		look_at(mousePos)
		last_angle = mousePos
		shootAngle = get_pos().angle_to_point(mousePos)
		#last_angle = shootAngle + 3.14159
		shootAngle = - (shootAngle - 3.14159/2) + 3.141519
		isShooting = true
		
		
		get_node("Weapon").fire_weapon(shootAngle)
		
	else:
		isShooting = false
	
	
func _input(ev):
		# Mouse rotation		
	if (ev.type==InputEvent.MOUSE_MOTION):
		mousePos =  get_global_mouse_pos()
	
	#if (ev.type==InputEvent.MOUSE_BUTTON):
	#	if ev.is_action_pressed("M_SEC_SHOOT"):			
	#		OS.set_time_scale(0.5)#slow down the game 2 times
				

func add_life(lifeValue):
	if is_dead:
		return
		
	if has_shield and lifeValue < 0:
		shield_damage +=lifeValue
		if shield_damage <= 0:
			has_shield = false
			update() # redraw 
		return
	if lifeValue < 0:
		get_node("/root/TestLevel/ui/top").set_texture(load("res://Game/GUI/hud_top2.png"))
		get_node("/root/TestLevel/ui/bottom").set_texture(load("res://Game/GUI/hud_bottom2.png"))
		get_node("timer_damage").start()
		
	currentLife += lifeValue
	if currentLife > life:
		currentLife = life
		
	get_node("/root/TestLevel/ui/top/Life").set_value(currentLife)
	
	if currentLife <= 0:
		lives -= 1
		get_node("/root/TestLevel/ui/top/lives").set_text(str(lives))
		get_node("Particles2D").set_emitting(true)
		set_process(false)
		get_node("Timer").start()
		sound.play("Laser_05", true)	
		get_node("Sprite").hide()
		is_dead = true
		var prev_weapon = get_node("Weapon")
		remove_child(prev_weapon)
		prev_weapon.queue_free()
		var w = weapon_1.instance()		
		add_child(w)
		

func change_weapon():
	if weapon_level == 4:
		return
		
	var prev_weapon = get_node("Weapon")
	remove_child(prev_weapon)
	prev_weapon.queue_free()
	
	if weapon_level == 1:
		weapon_level = 2
		var w = weapon_2.instance()		
		add_child(w)
	elif weapon_level == 2:
		weapon_level = 3
		var w = weapon_3.instance()
		add_child(w)
	elif weapon_level == 3:
		weapon_level = 4
		var w = weapon_4.instance()
		add_child(w)

func add_shield(strength):
	shield_damage = strength
	has_shield = true
	update()
	
func _draw():
	if has_shield:
		var center = Vector2(0,0)
		var radius = 400
		var angle_from = 0
		var angle_to = 355
		var color = Color(0.18, 0.475, 0.729)
		draw_circle_arc( center, radius, angle_from, angle_to, color )


func draw_circle_arc( center, radius, angle_from, angle_to, color ):
    var nb_points = 32
    var points_arc = Vector2Array()

    for i in range(nb_points+1):
        var angle_point = angle_from + i*(angle_to-angle_from)/nb_points - 90
        var point = center + Vector2( cos(deg2rad(angle_point)), sin(deg2rad(angle_point)) ) * radius
        points_arc.push_back( point )

    for indexPoint in range(nb_points):
        draw_line(points_arc[indexPoint], points_arc[indexPoint+1], color, 4)

func _on_Timer_timeout():

	# place player
	var pre_pos = get_pos()
	for i in range (0,100): #try a hundred times
		var pos_x = randi()%(maze_size * 4 * 64) #maze:size * scale* tile_size
		var pos_y = randi()%(maze_size * 4 * 64)
		var tile_pos = maze_tilemap.world_to_map(Vector2(pos_x, pos_y)*1.0/maze_tilemap.get_scale().x)
		tile_pos = Vector2(floor(tile_pos.x), floor(tile_pos.y))
		if maze_tilemap.get_cellv(tile_pos) == 0:
			set_pos(Vector2(pos_x, pos_y))
			break
		if i == 99:
			set_pos(pre_pos)
			break
			
	get_node("Particles2D").set_emitting(false)	
	
	set_process(true)
	get_node("Sprite").show()
	currentLife = life
	is_dead = false
	get_node("/root/TestLevel/ui/top/Life").set_value(currentLife)

	
	

func _on_timer_damage_timeout():
	get_node("/root/TestLevel/ui/top").set_texture(load("res://Game/GUI/hud_top.png"))
	get_node("/root/TestLevel/ui/bottom").set_texture(load("res://Game/GUI/hud_bottom.png"))
