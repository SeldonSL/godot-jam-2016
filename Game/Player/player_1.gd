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
		
		if get_node("Sprite").get_frame() == 0:
			get_node("Sprite").set_frame(1)

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
	print (currentLife)
	currentLife += lifeValue
	if currentLife <= 0:
		print ("I am dead!, GAME OVER")
		#queue_free()
		
