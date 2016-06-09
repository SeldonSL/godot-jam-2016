
extends Node

# member variables here, example:
# var a=2
# var b="textvar"
export var enemies = 10
var enemy_1 = preload("res://Game/Enemies/enemy_1.tscn") # will load when parsing the script

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here

	place_enemies()


func place_enemies():
	for i in range (0, enemies):
		var pos_x = randi()%13000
		var pos_y = randi()%13000
		var enemy_node = enemy_1.instance()
		enemy_node.set_pos(Vector2(pos_x, pos_y))
		get_node("Enemies").add_child(enemy_node)
		