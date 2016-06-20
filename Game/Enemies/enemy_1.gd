
extends Area2D

# Enemy variables
var speed = 850 # movement speed
var life = 1 # total life Points
var power = 1 # damage done when hiting player or object
var aggressiveness = 0.5  # chase the player probability (1.0 always chasing, 0.0 never chase). It depends if player in sight
var fov = 400 # distance to see and go after player
var has_weapon = false # true if a a weapon
var weapon_energy = -1 # -1 if no weapon, 0 -> 1 otherwise

var color_red = Color(0.635, 0.071, 0.196)
var color_dark = Color(0, 0, 0)
var color_white = Color(0.871, 0.808, 0.612)
var color_green = Color(0.125, 0.38, 0.357)


#Enemy state
var current_aggressiveness = aggressiveness
var currentLife = life # current life points. If zero = dead
var path = [] # current navigation path
var is_moving = false
var has_player_lock = false
var ang = 0



onready var sound = get_node("/root/menu_music/SamplePlayer")

func _ready():
	# Initialization here
	randomize()
	add_to_group("enemies")
	
	var w = randf()*0.4 + 0.8
	var h = randf()*0.4 + 0.8
	set_process(true)
	update()
	set_scale(Vector2(w * get_scale().x,h*get_scale().y))
	
	
	
	
func _process(delta):

	var player_pos = get_node("../../../TestLevel/Human Player").get_pos()
	#check if player is close -> follow
	if !has_player_lock:

		var dist = get_pos().distance_to(player_pos)
		if dist < fov: 
			path = []
			current_aggressiveness = 1.0
			has_player_lock = true
		else:
			
			has_player_lock = false
			current_aggressiveness = aggressiveness
		
	if (is_moving):
		## Movimiento nav-mesh
		var dir = Vector2(0,0)
		if (path.size()>1):
			
			var to_walk = delta*speed
			while(to_walk>0 and path.size()>=2):
				var pfrom = path[path.size()-1]
				var pto = path[path.size()-2]
				var d = pfrom.distance_to(pto)
				if (d<=to_walk):
					path.remove(path.size()-1)
					to_walk-=d
				else:
					path[path.size()-1] = pfrom.linear_interpolate(pto,to_walk/d)
					to_walk=0
					
			var atpos = path[path.size()-1]	
			
			ang = get_pos().angle_to_point(atpos)
			set_rot(ang)
			
			#noise
			var noise_x = randi()%10-5
			var noise_y = randi()%10-5
			
			set_pos(atpos + Vector2(noise_x, noise_y))
			
			
			#print (ang)

			if (path.size()<2):
				path=[]
				is_moving = false

					
		else:
			is_moving = false

			pass

			
	else: # generate new path
		
		var x = randi() % int(12900) # FIX
		var y = randi() % int(12900) #FIX

		var explorer_pos = Vector2(x,y)
		var path_pos = current_aggressiveness * player_pos + (1-current_aggressiveness)*explorer_pos
		path = Array(get_node("../../../TestLevel/Maze").generate_path(get_pos(),path_pos))
		path.invert()
		is_moving = true



func add_life(lifeValue):
	#print (currentLife)
	currentLife += lifeValue
	if currentLife <= 0:
		get_node("Particles2D").set_emitting(true)
		set_process(false)
		get_node("Timer").start()
		set_monitorable(false)
		sound.play("Laser_05", true)
		update()


func _on_Enemy_area_enter( area ):
	if (area.has_method("add_life")):
		area.add_life(-power)


func _on_Enemy_body_enter( body ):
	if (body.has_method("add_life")):
		body.add_life(-power)


func _draw():
	var n_circles = 0
	if has_weapon:
		n_circles += 1
	if life >= 10:
		n_circles += 1
	if power >=3:
		n_circles += 1
	if weapon_energy >= 0.5:
		n_circles += 1

	if currentLife > 0:
		draw_circle(Vector2(0,0),200, color_red)	
		draw_circle(Vector2(0,0),160, color_white)	
		for i in range (0,4):
			var x = randi()%100-50
			var y = randi()%100-50
			draw_circle(Vector2(x,y),40, color_red)
			draw_circle(Vector2(x,y),20, color_dark)	
		
	else:
		pass


	
	
	
func _on_Timer_timeout():
	var x = randi() % int(12900)#FIX
	var y = randi() % int(12900)
	get_node("Particles2D").set_emitting(false)	
	set_pos(Vector2(x,y))
	set_process(true)
	path = []
	currentLife = life
	set_monitorable(true)
	current_aggressiveness = aggressiveness
	update()