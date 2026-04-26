extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_button_down():
	GlobalRes.SaveCurrentGameStatus()
	#camera.last_position = camera.position
	camera.reset()
	get_tree().change_scene_to_file("res://Scene/main.tscn")
	pass # Replace with function body.
