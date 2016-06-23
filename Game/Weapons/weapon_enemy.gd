
extends Node

var n_bullets = 5
var ang_speed = PI/2
var time_1 = 0
var time_2 = 0
var n_rounds = 2



var bullet = preload("res://Game/Weapons/bullet_2.tscn")
var angle_step =  2*PI / n_bullets
var rot_step = ang_speed
var rounds_shot = 0
var enemy_speed = 0
var is_active = true

#onready var sound = get_node("/root/menu_music/SamplePlayer")


func _ready():
	randomize()
	time_1 = randf()*4 + 4
	get_node("Timer").set_wait_time(time_1)
	
func update_params():
	angle_step =  2*PI / n_bullets
	get_node("Timer").set_wait_time(time_1)
	get_node("Timer 2").set_wait_time(time_2)
	rot_step = ang_speed
	
func fire_weapon():
	if !is_active:
		return
	enemy_speed = get_parent().speed
	get_parent().speed = 0
	if rounds_shot >= n_rounds:
		rounds_shot = 0
		get_node("Timer 2").stop()
		get_parent().speed = enemy_speed
	else:
		get_node("Timer 2").start()



func fire_round():
	
	rounds_shot += 1
	if rounds_shot >= n_rounds:
		rounds_shot = 0
		get_node("Timer 2").stop()
		get_parent().speed = enemy_speed
	
	var angle = rot_step
	for b in range (0, n_bullets):
		# create bullet node
		var b = bullet.instance()
		b.set_rot(3*PI/2-angle)
		# set initial angle
		var dir_angle = Vector2(45 * cos(angle), 45 * sin(angle)) 
		b.set_pos(get_parent().get_pos() + dir_angle)
		b.set_angle(angle)
		add_child(b)
		angle += angle_step 
	
	rot_step += ang_speed
		
	
	# play sound
	#sound.play("Laser_09", true)
		

