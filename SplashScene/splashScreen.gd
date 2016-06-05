
extends Node2D

const STATE_INIT = 0
const STATE_FADEIN = 1
const STATE_SHOWING = 2
const STATE_FADEOUT = 3
const STATE_FINISHED = 4
var state = STATE_INIT

var alpha = 0;
export var fadeSpeed = 0.5;
export var initTime = 1 #in seconds
export var showingTime = 4
export var logo_scale = Vector2(1.0,1.0)
var timeWaited = 0

var logo = null

func _ready():
	logo = get_node("myLogo")
	logo.set_scale(logo_scale)
	logo.set_modulate(Color(255,255,255,alpha))
	set_process(true)

func getSplashScreenState():
	return state

func _process(delta):
	if state == STATE_INIT:
		timeWaited += delta
		if timeWaited >= initTime:
			timeWaited = 0
			state = STATE_FADEIN
			
	elif state == STATE_FADEIN:
		alpha += fadeSpeed * delta
		logo.set_modulate(Color(1,1,1,alpha))
		if alpha >= 1:
			alpha = 1
			state = STATE_SHOWING
			
	elif state == STATE_SHOWING:
		timeWaited += delta
		if timeWaited >= showingTime:
			state = STATE_FADEOUT
			
	elif state == STATE_FADEOUT:
		alpha -= fadeSpeed * delta
		logo.set_modulate(Color(1,1,1,alpha))
		if alpha <= 0:
			state = STATE_FINISHED
			
	else:
		set_process(false)
		#Go to main menu scene
		get_node("/root/sceneManager").goto_scene("res://MainMenuScene/main_menu.tscn")

		
	pass

