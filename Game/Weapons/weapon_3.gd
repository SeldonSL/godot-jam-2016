extends Node

var weaponReady = true
var angle_noise =  [-3.14159/100, 0, 3.14159/100]
var angle_noise_index = 0
var bullet_pro = preload("res://Game/Weapons/bullet_pro1.tscn")
var bullet = preload("res://Game/Weapons/bullet_1.tscn")
var weapon = preload("res://Game/Weapons/weapon_1.tscn")



func _ready():
	pass
	
func fire_weapon(angle):
	
	if (weaponReady):

		# play sound effect		
		#get_tree().get_root().get_node("TestLevel/SamplePlayer").play("Shoot_06")
		
		
		# Bullet pros
		var b_pro = bullet_pro.instance()
		b_pro.set_rot(3*PI/2-angle)
		var dir_angle = Vector2(45 * cos(angle), 45 * sin(angle)) 
		b_pro.set_pos(get_parent().get_pos() + dir_angle)
		b_pro.set_angle(angle)
		add_child(b_pro)
		var b_1 = bullet_pro.instance()
		var b_2 = bullet_pro.instance()
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
		
		# Side bullets
		var bs_1 = bullet.instance()
		var bs_2 = bullet.instance()
		var angle_s1 = angle + PI/8
		var angle_s2 = angle - PI/8
		bs_1.set_rot(3*PI/2-angle_s1)
		bs_2.set_rot(3*PI/2-angle_s2)
		var dir_angle_s1 = Vector2(45 * cos(angle_s1), 45 * sin(angle_s1)) 
		var dir_angle_s2 = Vector2(45 * cos(angle_s2), 45 * sin(angle_s2)) 
		bs_1.set_pos(get_parent().get_pos() + dir_angle_s1)
		bs_2.set_pos(get_parent().get_pos() + dir_angle_s2)
		bs_1.set_angle(angle_s1)
		bs_2.set_angle(angle_s2)
		add_child(bs_1)
		add_child(bs_2)
		
		
		# reset timer for next bullet
		weaponReady = false
		get_node("Timer").start()
		
func _on_Timer_timeout():
	weaponReady = true

func _on_ActiveTimer_timeout():
	var parent = get_parent()
	parent.remove_child(self)
	parent.add_child(weapon.instance())
	self.queue_free()
