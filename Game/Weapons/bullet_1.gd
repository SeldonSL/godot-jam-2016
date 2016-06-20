
extends Area2D

export var Speed = 1
var angle = Vector2(0,0)
var viewport_size = Vector2(0,0)
export var Damage = 1

func _ready():
	set_fixed_process(true)
	viewport_size = get_viewport_rect().size
	add_to_group("bullets")

	
func _fixed_process(delta):
	
	var pos = self.get_pos()	


	pos += Vector2(cos(angle) * Speed * delta, sin(angle) * Speed * delta)	
	self.set_pos(pos)

		
func set_angle(angle_in):	
	angle = angle_in


func _on_Timer_timeout():
	self.queue_free()
	

func _on_Bullet_area_enter( area ):
	print (area)
	if (area.has_method("add_life")):
		area.add_life(-Damage)
		self.queue_free() 


func _on_Bullet_body_enter( body ):
	if (body.has_method("add_life")):
		body.add_life(-Damage)

	self.queue_free() 
