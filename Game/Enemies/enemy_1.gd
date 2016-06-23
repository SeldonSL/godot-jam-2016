
extends Area2D

# Enemy variables
var speed = 850 # movement speed
var life = 10 # total life Points
var power = 5 # damage done when hiting player or object
var aggressiveness = 0.5  # chase the player probability (1.0 always chasing, 0.0 never chase). It depends if player in sight
var fov = 600 # distance to see and go after player
var has_weapon = true # true if a a weapon
var weapon_energy = -1 # -1 if no weapon, 0 -> 1 otherwise

var color_red = Color(0.635, 0.071, 0.196)
var color_dark = Color(0, 0, 0)
var color_white = Color(0.871, 0.808, 0.612)
var color_blue = Color(0.125, 0.38, 0.357)


#Enemy state
var current_aggressiveness = aggressiveness
var currentLife = life # current life points. If zero = dead
var path = [] # current navigation path
var is_moving = false
var has_player_lock = false
var ang = 0
var angle_draw = 0


onready var sound = get_node("/root/menu_music/SamplePlayer")

func _ready():

	#scale
	randomize()
	var wh_ratio = randf()*0.4 + 0.6
	angle_draw = randi()%60 + 30
	set_scale(Vector2(get_scale().x * wh_ratio, get_scale().y))
	currentLife = life
	current_aggressiveness = aggressiveness
	#add to group and enable process
	add_to_group("enemies")
	set_process(true)
	# draw	
	update() 

func update_params():
	currentLife = life
	current_aggressiveness = aggressiveness
	update()
	
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
			
		# TODO: activate weapon
		
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
			var noise_x = 0
			var noise_y = 0
			if life <= 3:
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
	



func _on_Enemy_area_enter( area ):
	if (area.has_method("add_life")):
		area.add_life(-power)


func _on_Enemy_body_enter( body ):
	if (body.has_method("add_life")):
		body.add_life(-power)
		get_node("Particles2D").set_emitting(true)
		set_process(false)
		get_node("Timer").start()
		set_monitorable(false)
		sound.play("Laser_05", true)
		currentLife = -1
		update()


func _draw():

	var border_ratio = -1 * tan(life * 0.075/10)*(power+2) + 5 * tan(life*0.075/10) + 0.5
	
	if currentLife > 0:
		draw_circle(Vector2(0,0), 60, color_red)
		draw_circle(Vector2(0,0), 60 * border_ratio, color_white)	
		var x = 0
		var y = 0
		var angle_tmp = angle_draw
		for i in range (0,currentLife-1):
			x = x + 90 * cos(angle_tmp)
			y = y + 90 * sin(angle_tmp)
			draw_circle(Vector2(x,y), 60, color_red)
			draw_circle(Vector2(x,y), border_ratio*60, color_white)	
			angle_tmp += angle_tmp
		
		
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