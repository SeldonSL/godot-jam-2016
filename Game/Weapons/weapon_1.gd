
extends Node

var weaponReady = true
var angle_noise =  [-3.14159/100, 0, 3.14159/100]
var angle_noise_index = 0
var bullet = preload("res://Game/Weapons/bullet_1.tscn")


func _ready():
	pass
	
func fire_weapon(angle):
	
	if (weaponReady):

		# play sound effect		
		#get_tree().get_root().get_node("TestLevel/SamplePlayer").play("Shoot_06")
		
		# create bullet node
		var b = bullet.instance()
		b.set_rot(3*PI/2-angle)
		add_child(b)
		
		# set initial angle

		var dir_angle = Vector2(45 * cos(angle), 45 * sin(angle)) 
		b.set_pos(get_parent().get_pos() + dir_angle)
		b.set_angle(angle + angle_noise[angle_noise_index % 3])
		angle_noise_index += 1
		if (angle_noise_index == 9):
			angle_noise_index == 0
				
		# reset timer for next bullet
		weaponReady = false
		get_node("Timer").start()
		
func _on_Timer_timeout():
	weaponReady = true


