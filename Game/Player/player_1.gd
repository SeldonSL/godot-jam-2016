# Keyboard + mouse player
extends KinematicBody2D

# Actions
export var speed = 3 # player speed
export var life = 100 # player life
var isShooting = false
var shootAngle = 0
var last_angle = Vector2(0,0)
var mousePos = Vector2(0,0)
var currentLife = life
var weapon_level = 1

var weapon_2 = preload("res://Game/Weapons/weapon_2.tscn")
var weapon_3 = preload("res://Game/Weapons/weapon_3.tscn")
var weapon_4 = preload("res://Game/Weapons/weapon_4.tscn")

var has_shield = false
var shield_damage = 0

# Keyboard Movement actions
var move_actions = { "K_MOVE_LEFT":Vector2(-1,0), "K_MOVE_RIGHT":Vector2(1,0), "K_MOVE_UP":Vector2(0,-1), "K_MOVE_DOWN":Vector2(0,1) }

var path = []

func _ready():
	set_process(true)
	set_process_input(true)
	

func _process(delta):	
	
	# Movement
	var dir = Vector2(0,0)
	
	for ac in move_actions:
		if Input.is_action_pressed(ac):
			dir += move_actions[ac]
			
	move(dir.normalized() * speed * delta)
	if dir == Vector2(0,0):
		look_at(last_angle)
	else:
		
		set_rot(Vector2(0,0).angle_to_point(dir)-3.14159 )
	
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
	
	if (ev.type==InputEvent.MOUSE_BUTTON):
		if ev.is_action_pressed("M_SEC_SHOOT"):			
			OS.set_time_scale(0.5)#slow down the game 2 times
				

func add_life(lifeValue):
	if has_shield and lifeValue < 0:
		shield_damage +=lifeValue
		if shield_damage <= 0:
			has_shield = false
			update() # redraw 
		return
	
	currentLife += lifeValue
	if currentLife <= 0:
		print ("I am dead!, GAME OVER")
		return
		queue_free()
	if currentLife > life:
		currentLife = life


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