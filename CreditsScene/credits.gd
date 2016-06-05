
extends Node

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initialization here
	get_tree().set_auto_accept_quit(false) 

func _notification(what):
    if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
        get_node("/root/sceneManager").goto_scene("res://MainMenuScene/main_menu.tscn")   



func _on_TextureButton_pressed():
	get_node("/root/sceneManager").goto_scene("res://MainMenuScene/main_menu.tscn")   
