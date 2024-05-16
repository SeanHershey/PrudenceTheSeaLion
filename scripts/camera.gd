extends Camera2D

var smooth_zoom = 1
var target_zoom = 1
var sliding = 0
var looking = true

const ZOOM_SPEED = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	limit_left = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	
	if Input.is_action_pressed("look") and direction == 0:
		looking = true
		target_zoom = 0.7
	elif Input.is_action_just_released("look"):
		looking = false
		target_zoom = 1
		
	if Input.is_action_just_pressed("slide"):
		target_zoom = 1.3
		sliding = 85 
	
	if sliding > 0:
		sliding -= 1
	elif looking == false:
		target_zoom = 1
	
	smooth_zoom = lerpf(smooth_zoom, target_zoom, ZOOM_SPEED * delta)
	if smooth_zoom != target_zoom:
		set_zoom(Vector2(smooth_zoom, smooth_zoom))
