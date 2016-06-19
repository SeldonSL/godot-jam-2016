
extends Area2D

# Enemy variables
var speed = 850 # movement speed
var life = 1 # total life Points
var power = 1 # damage done when hiting player or object
var aggressiveness = 1.0  # chase the player probability (1.0 always chasing, 0.0 never chase). It depends if player in sight


var currentLife = 0 # current life points. If zero = dead
var path = [] # current navigation path
var is_moving = false
var ang = 0

var color_red = Color(0.635, 0.071, 0.196)
#var color_dark = Color(0.102, 0.094, 0.192)
var color_dark = Color(0, 0, 0)
var color_white = Color(0.871, 0.808, 0.612)
#var color_white = Color(1, 1, 1)
var color_green = Color(0.125, 0.38, 0.357)

func _ready():
	# Initialization here
	randomize()
	currentLife = life
	add_to_group("enemies")
	set_process(true)
	var w = randf()*0.4 + 0.8
	var h = randf()*0.4 + 0.8
	update()
	set_scale(Vector2(w * get_scale().x,h*get_scale().y))
	
	
	
	
func _process(delta):

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

			
	else:		
		#randomize()		
		var x = randi() % int(12900)
		var y = randi() % int(12900)
			
		path = Array(get_node("../../../TestLevel/Maze").generate_path(get_pos(),get_node("../../../TestLevel/Human Player").get_pos()))
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
		update()



func _on_Shoot_timer_timeout():
	get_node("Weapon").fire_weapon(0)


func _on_Enemy_area_enter( area ):
	if (area.has_method("add_life")):
		area.add_life(-power)


func _on_Enemy_body_enter( body ):
	if (body.has_method("add_life")):
		body.add_life(-power)


func _draw():
	if currentLife > 0:
		draw_circle(Vector2(0,0),60, color_red)
		draw_circle(Vector2(0,0),30, color_white)
	else:
		pass


	
	
	
func _on_Timer_timeout():
	var x = randi() % int(12900)
	var y = randi() % int(12900)
	get_node("Particles2D").set_emitting(false)	
	set_pos(Vector2(x,y))
	set_process(true)
	path = []
	currentLife = life
	set_monitorable(true)
	update()