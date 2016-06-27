
extends Sprite

var pos = Vector2(0,0)

func _ready():
	randomize()
	var x = randi()%1280
	var y = 1000
	pos = Vector2(x,y)
	var x2 = randi()%1280
	var y2 = randi()%720
	set_pos(Vector2(x2,y2))	
	set_process(true)

func _process(delta):
	var p = get_pos()
	var noise_x = randi()%10-5
	var noise_y = randi()%10-5
	
	set_pos(get_pos() + delta*(pos-p)*0.7+Vector2(noise_x, noise_y))
	if get_pos().y >= 750:
		var x = randi()%1280
		var y = -500
		pos = Vector2(x,y)
	if get_pos().y <= -300:
		var x = randi()%1280
		var y = 1000
		pos = Vector2(x,y)
		