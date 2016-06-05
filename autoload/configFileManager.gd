
extends Node

var configFile = ConfigFile.new()
var music = true
var soundfx = true

func _ready():
	var err = configFile.load("optionsFile.txt")
	if(err):
		configFile.set_value("General", "Music", music)
		configFile.set_value("General", "SoundFx", soundfx)
		configFile.save("optionsFile.txt")
	else:
		music = configFile.get_value("General", "Music")
		soundfx = configFile.get_value("General", "SoundFx")
		
func getMusic():
	return music

func getSoundFx():
	return soundfx

func setMusic(play_music):
	music = play_music
	configFile.set_value("General", "Music", music)
	configFile.save("optionsFile.txt")
	
func setSoundFX(play_soundfx):
	soundfx = play_soundfx
	configFile.set_value("General", "SoundFx", soundfx)
	configFile.save("optionsFile.txt")



