
extends Node2D

export var strength = 50

func _on_Area2D_body_enter( body ):

	if (body.has_method("add_shield")):
		body.add_shield(strength)
		self.queue_free()
				
