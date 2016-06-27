extends Node


func _ready():
	# Initialization here
	get_tree().set_auto_accept_quit(false) 
	var music_toggle = get_node("/root/configFileManager").getMusic()
	var sound_toggle = get_node("/root/configFileManager").getSoundFx()
	var fullscreen_toggle = get_node("/root/configFileManager").getFullscreen()
	
	get_node("MusicButton").set_pressed(music_toggle)
	get_node("SoundFXButton").set_pressed(sound_toggle)
	get_node("FullscreenButton").set_pressed(fullscreen_toggle)

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
		get_node("/root/menu_music/SamplePlayer").set_default_volume_db(0)
	else:
		get_node("/root/menu_music/SamplePlayer").set_default_volume_db(-80)

	get_node("/root/configFileManager").setSoundFX(pressed)

func _on_FullscreenButton_toggled( pressed ):
	if pressed:
		OS.set_window_fullscreen(true)
	else:
		OS.set_window_fullscreen(false)

	get_node("/root/configFileManager").setFullscreen(pressed)
