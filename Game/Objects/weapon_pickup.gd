
extends Node2D

func _on_Area2D_body_enter( body ):


	if (body.has_method("change_weapon")):
		body.change_weapon()
				
		self.queue_free()