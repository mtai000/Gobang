extends Camera2D

@onready var default_windows_size = DisplayServer.window_get_size()
@onready var target_position : Vector2
@onready var move_step :Vector2
const default = Vector2(640,360)
var first_time_load = true
var map_position
# Called when the node enters the scene tree for the first time.
func _ready():
	var w_size = default_windows_size
	var new_zoom = Vector2(1.0*default_windows_size.x /w_size.x, 1.0*default_windows_size.y/w_size.y)
	set_zoom(new_zoom)
	map_position = position
	reset()
	target_position = position
	$bgm.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if(abs(camera2d.position - target_position).length_squared() > 10):
	#	camera2d.position += move_step * delta
	#camera2d.position = target_position
	pass

func reset():
	position = default

func _physics_process(delta):
	pass


func move_to(target,time):
	var interval = 0.02
	var step = (target - position) / time * interval
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	while (abs(position - target).length_squared() > 10):
		position += step
		await( get_tree().create_timer(interval).timeout)
	position = target
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	first_time_load = false
	pass
