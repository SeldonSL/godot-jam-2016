extends Node

var weaponReady = true
var angle_noise =  [-3.14159/100, 0, 3.14159/100]
var angle_noise_index = 0
var bullet = preload("res://Game/Weapons/bullet_1.tscn")
onready var sound = get_node("/root/menu_music/SamplePlayer")



func _ready():
	pass
	
func fire_weapon(angle):
	
	if (weaponReady):

		# center bullet
		var b_c = bullet.instance()
		b_c.set_rot(3*PI/2-angle)
		var dir_angle = Vector2(45 * cos(angle), 45 * sin(angle)) 
		b_c.set_pos(get_parent().get_pos() + dir_angle)
		b_c.set_angle(angle)
		add_child(b_c)
		
		# Side bullets
		var b_1 = bullet.instance()
		var b_2 = bullet.instance()
		var angle_1 = angle + PI/20
		var angle_2 = angle - PI/20
		b_1.set_rot(3*PI/2-angle_1)
		b_2.set_rot(3*PI/2-angle_2)
		var dir_angle_1 = Vector2(45 * cos(angle_1), 45 * sin(angle_1)) 
		var dir_angle_2 = Vector2(45 * cos(angle_2), 45 * sin(angle_2)) 
		b_1.set_pos(get_parent().get_pos() + dir_angle_1)
		b_2.set_pos(get_parent().get_pos() + dir_angle_2)
		b_1.set_angle(angle_1)
		b_2.set_angle(angle_2)
		add_child(b_1)
		add_child(b_2)
		
	
		# reset timer for next bullet
		weaponReady = false
		get_node("Timer").start()
		
		# play sound
		sound.play("Laser_09", true)
		
func _on_Timer_timeout():
	weaponReady = true

