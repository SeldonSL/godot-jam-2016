
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
	if (pos.x > (viewport_size.x - 32) or pos.x < 32):
		self.queue_free()
	if (pos.y > (viewport_size.y - 32) or pos.y < 32):
		self.queue_free()		

	pos += Vector2(cos(angle) * Speed * delta, sin(angle) * Speed * delta)	
	self.set_pos(pos)

		
func set_angle(angle_in):	
	angle = angle_in


func _on_Timer_timeout():
	self.queue_free()
	

func _on_Bullet_area_enter( area ):

	if (area.has_method("add_life")):
		area.add_life(-Damage)
		self.queue_free() 