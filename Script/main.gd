extends Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(FileAccess.file_exists(GlobalRes.continue_scene)):
		$Control/Continue.visible = true
	else:
		$Control/Continue.visible = false
	pass

func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scene/options.tscn")
	pass # Replace with function body.

func initiatePlayerStatus():
	GlobalRes.player_max_health = 200
	GlobalRes.player_health = 200

func _on_new_pressed():
	GlobalRes.map_id = 0
	GlobalRes.seed = str(randi())
	for i in 10:
		GlobalRes.add_a_piece("1",1)
	GlobalRes.rng.seed = hash(str(Time.get_ticks_usec()))
	GlobalRes.player_position = Vector2(640,3400)
	initiatePlayerStatus()
	get_tree().change_scene_to_file("res://Scene/select_reward_treasure.tscn")
	#get_tree().change_scene_to_file("res://Scene/map.tscn")
	
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.

func _on_continue_pressed():
	camera.position = camera.map_position
	GlobalRes.ContinueLastGame()
	pass # Replace with function body.
