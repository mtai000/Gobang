extends Node2D

var select_item : int = -1
var array
signal  select_piece(id)
# Called when the node enters the scene tree for the first time.
func _ready():
	#array = GlobalRes.piece_type_json.keys().slice(2, GlobalRes.piece_type_json.keys().size())
	refresh()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_piece(i,id):
	id = str(id)
	var piece_scene = preload("res://Scene/PieceItem.tscn").instantiate()
	piece_scene.position = Vector2(240 + i * 200 , 260)
	piece_scene.scale =Vector2(2,2)
	piece_scene.id = id
	piece_scene.name = "item_" + str(i)
	piece_scene.select_piece.connect(_select_piece)
	piece_scene.level = GlobalRes.rng.randi() % int(GlobalRes.piece_type_json[id]["max_level"]) + 1
	$group.add_child(piece_scene)
	
func refresh():
	for node in $group.get_children():
		node.queue_free()
	var array  = []
	while(array.size() <= 3):
		var t = GlobalRes.rng.randi() % GlobalRes.piece_total_weight
		var weight = 0
		for name in GlobalRes.piece_type_json:
			weight += GlobalRes.piece_type_json[name]["weight"]
			if(t < weight and (not name in array)):
				array.append(GlobalRes.piece_type_json[name]["ID"])
			
	#array.shuffle()
	set_piece(1 , array[0])
	set_piece(2 , array[1])
	set_piece(3 , array[2])
	
	
func _select_piece(name,id,level):
	GlobalRes.add_a_piece(str(id),level)
	get_tree().change_scene_to_file("res://Scene/map.tscn")
	#print(id)


func _on_skip_pressed():
	get_tree().change_scene_to_file("res://Scene/map.tscn")
	pass # Replace with function body.


func _on_refresh_pressed():
	refresh()
	pass # Replace with function body.
