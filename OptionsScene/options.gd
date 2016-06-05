extends Node


func _ready():
	# Initialization here
	get_tree().set_auto_accept_quit(false) 
	var music_toggle = get_node("/root/configFileManager").getMusic()
	var sound_toggle = get_node("/root/configFileManager").getSoundFx()
	
	get_node("MusicButton").set_pressed(music_toggle)
	get_node("SoundFXButton").set_pressed(sound_toggle)

func _notification(what):
    if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
        get_node("/root/sceneManager").goto_scene("res://MainMenuScene/main_menu.tscn")   

func _on_TextureButton_pressed():
	get_node("/root/sceneManager").goto_scene("res://MainMenuScene/main_menu.tscn")   


func _on_MusicButton_toggled( pressed ):
	if pressed:
		get_node("/root/menu_music").play()
	else:
		get_node("/root/menu_music").stop()

	get_node("/root/configFileManager").setMusic(pressed)


func _on_SoundFXButton_toggled( pressed ):
	if pressed:
		pass
	else:
		pass

	get_node("/root/configFileManager").setSoundFX(pressed)