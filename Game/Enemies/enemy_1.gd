
extends Area2D

var path =[]
var is_moving = true
var is_monster = false
export var speed = 50
export var Life = 1

var is_idle = false
var ang = 0
var timeElapsed = 0
var state = 0 # 0 normal, 1: go to exit
var exit_pos = Vector2(0,0)
var currentLife = 0

func _ready():
	# Initialization here
	currentLife = Life
	add_to_group("enemies")
	set_process(true)
	
	
	
	
func _process(delta):

	if (is_moving):
		is_idle = false
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
			#print ("Pos "+ str(get_pos()))
			#print ("atpos "+ str(atpos))
			ang = get_pos().angle_to_point(atpos)
			set_pos(atpos)
			
			
			#print (ang)

			if (path.size()<2):
				path=[]
				is_moving = false
				is_idle = true
					
		else:
			is_moving = false
			is_idle = true
			pass

			
	else:
		pass
		is_idle = true
		if (state == 0):
			randomize()
			var x = randi() % int(12900)
			var y = randi() % int(12900)
	
			path = Array(get_node("../../../TestLevel/Maze").generate_path(get_pos(),Vector2(x,y)))
			path.invert()
			is_moving = true
		else:
			pass
			
	


func add_life(lifeValue):
	print (currentLife)
	currentLife += lifeValue
	if currentLife <= 0:
		queue_free()




func _on_Shoot_timer_timeout():
	get_node("Weapon").fire_weapon(0)
