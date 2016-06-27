
extends Node

var configFile = ConfigFile.new()
var music = true
var soundfx = true
var fullscreen = false
var level = 0
var maze_size = 50
var n_enemies = 100

func _ready():
	var err = configFile.load("optionsFile.txt")
	if(err):
		configFile.set_value("General", "Music", music)
		configFile.set_value("General", "SoundFx", soundfx)
		configFile.set_value("General", "Fullscreen", fullscreen)
		configFile.set_value("Game", "Level", level)
		configFile.set_value("Game", "MazeSize", maze_size)
		configFile.set_value("Game", "Enemies", n_enemies)
		
		configFile.save("optionsFile.txt")
	else:
		music = configFile.get_value("General", "Music")
		soundfx = configFile.get_value("General", "SoundFx")
		fullscreen = configFile.get_value("General", "Fullscreen")
		level = configFile.get_value("Game", "Level")
		maze_size = configFile.get_value("Game", "MazeSize")
		n_enemies = configFile.get_value("Game", "Enemies")
		
		
func getMusic():
	return music

func getSoundFx():
	return soundfx

func getFullscreen():
	return fullscreen
	
func getLevel():
	return level

func getMazeSize():
	return maze_size

func setMusic(play_music):
	music = play_music
	configFile.set_value("General", "Music", music)
	configFile.save("optionsFile.txt")
	
func setSoundFX(play_soundfx):
	soundfx = play_soundfx
	configFile.set_value("General", "SoundFx", soundfx)
	configFile.save("optionsFile.txt")

func setFullscreen(fullscreen_value):
	fullscreen = fullscreen_value
	configFile.set_value("General", "Fullscreen", fullscreen)
	configFile.save("optionsFile.txt")


