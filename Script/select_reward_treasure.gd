extends Node2D

var treasure

# Called when the node enters the scene tree for the first time.
func _ready():
	treasure = random_a_treasure()
	var texture = load(treasure["path"])
	$treasure.texture = texture
	$describe.text = treasure[GlobalRes.Language]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func random_a_treasure():
	var rd = randi() % GlobalRes.treasure_total_weight
	var weight = 0
	for name in GlobalRes.treasure_type_json:
		weight += GlobalRes.treasure_type_json[name]["weight"]
		if(rd < weight):
			return GlobalRes.treasure_type_json[str(name)]
	


func _on_skip_pressed():
	get_tree().change_scene_to_file("res://Scene/map.tscn")
	pass # Replace with function body.


func _on_area_2d_input_event(viewport, event, shape_idx):
	if(event.is_action_pressed("click")):
		GlobalRes.treasureArray.append(treasure)
		get_tree().change_scene_to_file("res://Scene/map.tscn")
	pass # Replace with function body.
