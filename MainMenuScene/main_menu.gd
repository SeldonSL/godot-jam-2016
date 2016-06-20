
extends Node

## Signals to go to other menus go in this script



func _ready():
	# Called every time the node is added to the scene.
	# Initialization here	
	
	#Turn off quitting
	get_tree().set_auto_accept_quit(false) 


func _on_PlayButton_pressed():
	get_node("/root/sceneManager").goto_scene("res://Game/test_level.tscn")


func _on_OptionsButton_pressed():
	#Go to credits scene
	get_node("/root/sceneManager").goto_scene("res://OptionsScene/options.tscn")


func _on_CreditsButton_pressed():
	#Go to credits scene
	get_node("/root/sceneManager").goto_scene("res://CreditsScene/credits.tscn")
	


func _on_ExitButton_pressed():
	get_tree().set_pause(true)
	get_node("ExitPopup").popup_centered()	

func _on_OKButton_pressed():
    get_tree().quit() # default behavior


func _on_CancelButton1_pressed():
	get_node("ExitPopup").hide()
	get_tree().set_pause(false)

func _notification(what):
    if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
        _on_ExitButton_pressed()        
