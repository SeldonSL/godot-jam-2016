
extends StreamPlayer

var play_music = true

func _ready():
	play_music = get_node("/root/configFileManager/").getMusic()
	if play_music:
		play()





func _on_MenuMusic_finished():
	pass # replace with function body
