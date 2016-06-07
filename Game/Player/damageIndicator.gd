
extends Node

# member variables here, example:
# var a=2
# var b="textvar"

var speed = 40
var scale_speed = 1
var scale_opacity = 1.8
onready var label = self.get_node("Label")

func _ready():
	set_process(true)

func _process(delta):
	label.set_pos(label.get_pos() + Vector2(speed * delta*1.5, -speed * delta))
	label.set_scale(label.get_scale() *  Vector2(1 + scale_speed*delta, 1 + scale_speed*delta))
	label.set_opacity(label.get_opacity() -  scale_opacity*delta)
	

func _on_Timer_timeout():
	queue_free()
