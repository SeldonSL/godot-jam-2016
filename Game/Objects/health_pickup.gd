
extends Node2D

export var healthValue = 20

func _on_Area2D_body_enter( body ):

	if (body.has_method("add_life")):
		body.add_life(healthValue)
		self.queue_free()
				
