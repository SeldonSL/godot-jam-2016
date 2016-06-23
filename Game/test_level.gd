
extends Node

export var enemies = 100
var enemy_1 = preload("res://Game/Enemies/enemy_1.tscn") # will load when parsing the script
var enemy_w = preload("res://Game/Weapons/weapon_enemy.tscn") # will load when parsing the script
var swarmer_percent = 0.5
var shooter_percent = 0.3
var monster_percent = 0.2
var enemy_energy = 2

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	randomize()
	
	for i in range(0, round(enemies*swarmer_percent)):
		create_enemy_swarmer(enemy_energy)
	for i in range(0, round(enemies*shooter_percent)):
		create_enemy_shooter(enemy_energy)
	for i in range(0, round(enemies*monster_percent)):
		create_enemy_monster(enemy_energy)
	
	#Start music
	get_node("/root/menu_music").in_game = true
	get_node("/root/menu_music").stop()

func create_enemy_swarmer(energy):

	var enemy_node = enemy_1.instance()
	# position
	var pos_x = randi()%13000#FIX
	var pos_y = randi()%13000#FIX
	enemy_node.set_pos(Vector2(pos_x, pos_y))
	
	# set parameters
	var param_array = generate_random_distribution(5, energy, null, 1.0)
	enemy_node.speed = 500 + round(param_array[0]*(1000-500))
	enemy_node.life = 1 + round(param_array[1]*3)
	enemy_node.power = 1 + round(param_array[2]*4)
	enemy_node.aggressiveness = 0.5 + param_array[3]*0.2
	enemy_node.fov = 500 + round(param_array[4]*200)
	enemy_node.has_weapon = false
	enemy_node.update_params()
	
	get_node("Enemies").add_child(enemy_node)

func create_enemy_shooter(energy):
	var enemy_node = enemy_1.instance()
	# position
	var pos_x = randi()%13000#FIX
	var pos_y = randi()%13000#FIX
	enemy_node.set_pos(Vector2(pos_x, pos_y))
	
	# set parameters
	var param_array = generate_random_distribution(6, energy, null, 1.0)
	enemy_node.speed = 350 + round(param_array[0]*(1000-350))
	enemy_node.life = 1 + round(param_array[1]*9)
	enemy_node.power = 1 + round(param_array[2]*4)
	enemy_node.aggressiveness = param_array[3]*0.8
	enemy_node.fov = 600 + round(param_array[4]*100)
		
	# add weapon
	enemy_node.has_weapon = true
	enemy_node.weapon_energy = param_array[5] * 2 + 1
	var weapon = enemy_w.instance()
	var weapon_params = generate_random_distribution(4, enemy_node.weapon_energy, null, 1.0)
	weapon.n_bullets = 1 + weapon_params[0]*9
	weapon.n_rounds = 1 + weapon_params[1]*2
	weapon.time_1 = 5 + weapon_params[2]*5
	weapon.time_2 = 0.3 + weapon_params[3]*0.7
	weapon.ang_speed = PI/6 + randf()*2*PI*6
	weapon.update_params()
	enemy_node.add_child(weapon)
	
	
	enemy_node.update_params()
	get_node("Enemies").add_child(enemy_node)

func create_enemy_monster(energy):
	var enemy_node = enemy_1.instance()
	# position
	var pos_x = randi()%13000#FIX
	var pos_y = randi()%13000#FIX
	enemy_node.set_pos(Vector2(pos_x, pos_y))
	
	# set parameters
	var param_array = generate_random_distribution(6, energy, null, 1.0)
	enemy_node.speed = 100 + round(param_array[0]*(900-100))
	enemy_node.life = 8 + round(param_array[1]*2)
	enemy_node.power = 3 + round(param_array[2]*2)
	enemy_node.aggressiveness = param_array[3]*0.5
	enemy_node.fov = 400 + round(param_array[4]*300)
	
	# add weapon
	var weapon_bool = randf()
	if weapon_bool >= 0.5:
		enemy_node.has_weapon = true
		enemy_node.weapon_energy = param_array[5] * 4 + 2
		var weapon = enemy_w.instance()
		var weapon_params = generate_random_distribution(4, enemy_node.weapon_energy, null, 1.0)
		weapon.n_bullets = 1 + weapon_params[0]*9
		weapon.n_rounds = 1 + weapon_params[1]*2
		weapon.time_1 = 5 + weapon_params[2]*5
		weapon.time_2 = 0.3 + weapon_params[3]*0.7
		weapon.ang_speed = PI/6 + randf()*2*PI*6
		weapon.update_params()
		enemy_node.add_child(weapon)
		
		
	enemy_node.update_params()
	get_node("Enemies").add_child(enemy_node)



func create_enemy_random(energy):
	var enemy_node = enemy_1.instance()
	# position
	var pos_x = randi()%13000#FIX
	var pos_y = randi()%13000#FIX
	enemy_node.set_pos(Vector2(pos_x, pos_y))
	
	# set parameters
	var param_array = generate_random_distribution(6, energy, null, 1.0)
	enemy_node.speed = 100 + round(param_array[0]*(1000-100))
	enemy_node.life = 1 + round(param_array[1]*9)
	enemy_node.power = 1 + round(param_array[2]*4)
	enemy_node.aggressiveness = param_array[3]
	enemy_node.fov = 400 + round(param_array[4]*300)
	
	# add weapon
	var weapon_bool = randf()
	if weapon_bool >= 0.5:
		enemy_node.has_weapon = true
		enemy_node.weapon_energy = param_array[5] * 3 + 1
		var weapon = enemy_w.instance()
		var weapon_params = generate_random_distribution(4, enemy_node.weapon_energy, null, 1.0)
		weapon.n_bullets = 1 + weapon_params[0]*9
		weapon.n_rounds = 1 + weapon_params[1]*2
		weapon.time_1 = 5 + weapon_params[2]*5
		weapon.time_2 = 0.3 + weapon_params[3]*0.7
		weapon.ang_speed = PI/6 + randf()*2*PI*6
		weapon.update_params()
		enemy_node.add_child(weapon)
		
	# update parameters
	enemy_node.update_params()
	get_node("Enemies").add_child(enemy_node)



# Generates N random numbers that sum M
func generate_random_distribution(N, M, min_num = null, max_num = null):
	var rand_array = []
	var out_array = []
	for tries in range(0,100):
		rand_array = []
		out_array = []
		
		if tries == 99:
			print ("not found")
			min_num = null
			max_num = null
		
		for i in range(0,N-1):
			var f = randf() * M
			rand_array.append(f)
	
		rand_array.append(0.0)
		rand_array.append(1.0 * M)
		rand_array.sort()
		
		for i in range(0,N):
			var tmp = rand_array[i+1]-rand_array[i]
			
			if min_num != null:
				if tmp <= min_num:
					break
			if max_num != null:
				if tmp >= max_num:
					break
			if tmp > 1.0:
				tmp = 1.0
			out_array.append(tmp)

		if (out_array.size()== N):
			break

	return out_array
	


func _notification(what):
    if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
        get_node("/root/sceneManager").goto_scene("res://MainMenuScene/main_menu.tscn")   