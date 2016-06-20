
extends StreamPlayer

var play_music = true
var tracks = [load("res://Music/1_0.ogg"), load("res://Music/2_0.ogg"), load("res://Music/3_0.ogg"),load("res://Music/4_0.ogg"), load("res://Music/5_0.ogg")]
var menu_music = load("res://Music/6_0.ogg")
var track_index = 0
var in_game = false

func _ready():
	play_music = get_node("/root/configFileManager/").getMusic()
	if play_music:
		play()

	# In-game Music
	tracks = shuffleArray(tracks)
	set_process(true)

func _process(delta):
	if(self.is_playing() != true):
		if in_game:
			set_stream(tracks[track_index])
			track_index += 1
			track_index = track_index % 5 
		else:
			set_stream(menu_music)
		play_music = get_node("/root/configFileManager/").getMusic()
		if play_music:
			play()
		


func shuffleArray(a):
	randomize()
	for i in range (0,a.size()-2):
		var j =  i + randi()%(a.size() - i)
		var tmp = a[i]
		a[i] = a[j]
		a[j] = tmp
	return a