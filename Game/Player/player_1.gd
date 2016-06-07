# Keyboard + mouse player
extends KinematicBody2D

# Actions
export var Speed = 3 # player speed
export var Life = 100 # player life
var isShooting = false
var shootAngle = 0
var last_angle = 0
var mousePos = Vector2(0,0)
var currentLife = Life
var playerNumber = 1
var acumDamage = 0
var damageInd = preload("res://Game/Player/damageIndicator.tscn")

# walk animation
var walk_animation_delta = 1
var walk_animation_timer = 1

# Keyboard Movement actions
var move_actions = { "K_MOVE_LEFT":Vector2(-1,0), "K_MOVE_RIGHT":Vector2(1,0), "K_MOVE_UP":Vector2(0,-1), "K_MOVE_DOWN":Vector2(0,1) }


func _ready():
	set_process(true)
	set_process_input(true)
	

func _process(delta):
	
	# Movement
	var dir = Vector2(0,0)
	
	for ac in move_actions:
		if Input.is_action_pressed(ac):
			dir += move_actions[ac]
			
	move(dir.normalized() * Speed * delta)
	if dir == Vector2(0,0):
		set_rot(last_angle)
	else:
		last_angle = Vector2(0,0).angle_to_point(dir)-3.14159 
		set_rot(last_angle)
	
	# Shooting
	if Input.is_action_pressed("M_SHOOT"):
		look_at(mousePos)
		shootAngle = get_pos().angle_to_point(mousePos)
		shootAngle = - (shootAngle - 3.14159/2) + 3.141519
		isShooting = true
		if get_node("Sprite").get_frame() == 0:
			get_node("Sprite").set_frame(1)
		#print (self)
		#print (get_child(0).get_name())
		#print (get_child(1).get_name())
		#print (get_child(2).get_name())
		get_node("Weapon").fire_weapon(shootAngle)
		
	else:
		isShooting = false
	
	# animation
	if dir != Vector2(0,0):
		walk_animation_timer += walk_animation_delta * delta	
	
	if walk_animation_timer > 0.2:
		if isShooting and get_node("Sprite").get_frame() == 1:
			get_node("Sprite").set_frame(2)
		elif isShooting and get_node("Sprite").get_frame() == 2:
			get_node("Sprite").set_frame(1)
		elif isShooting and get_node("Sprite").get_frame() == 0:
			get_node("Sprite").set_frame(1)
		elif not isShooting and get_node("Sprite").get_frame() == 0:
			get_node("Sprite").set_frame(1)
		elif not isShooting and get_node("Sprite").get_frame() == 1:
			get_node("Sprite").set_frame(0)	
		elif not isShooting and get_node("Sprite").get_frame() == 2:
			get_node("Sprite").set_frame(1)
		walk_animation_timer = 0
	
func _input(ev):
		# Mouse rotation
	if (ev.type==InputEvent.MOUSE_MOTION):
		mousePos = ev.pos
		

func add_life(lifeValue):
	#case is health
	if lifeValue > 0:
		currentLife += lifeValue
	
		
	# case is damage
	if lifeValue < 0:
		currentLife += lifeValue
		acumDamage += lifeValue
		get_tree().get_root().get_node("/root/TestLevel/GUI_P1/ProgressBar").set_value(currentLife)
	
		# Spawn Damage Indicator
		if acumDamage > 5:
			var d_i = damageInd.instance()
			d_i.get_node("Label").set_text("5")
			d_i.get_node("Label").set_scale(Vector2(0.6,0.6))
			d_i.get_node("Label").set_pos(get_pos())
			add_child(d_i)
			acumDamage = 0
		
	
	#Check for dead
	
func get_player_number():
	return playerNumber