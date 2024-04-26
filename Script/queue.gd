extends Node2D

var array = []
var reset_brownFrame_position : bool
var pieces_array
# Called when the node enters the scene tree for the first time.
func _ready():
	pieces_array  = GlobalRes.playerPieceDictArray.duplicate()
	pieces_array.shuffle()
	fill_select_area()
	fill_array()
	GlobalRes.need_select_a_piece = true
	#$BrownFrame.position = Vector2(536, 686)
	pass # Replace with function body.

func fill_select_area():
	if(pieces_array.size() < GlobalRes.queue_size):
		var temp = GlobalRes.playerPieceDictArray.duplicate()
		temp.shuffle()
		pieces_array.append_array(temp)
	else:
		for i in GlobalRes.queue_size:
			array.append(pieces_array.pop_front())

func fill_array():
	for i in array.size():
		var piece_scene = preload("res://Scene/PieceItem.tscn").instantiate()
		piece_scene.id = str(array[i]["ID"])
		piece_scene.level = array[i]["level"]
		piece_scene.base_value = array[i]["base_value"]
		piece_scene.lvup_value = array[i]["lvup_value"]
		piece_scene.describe = array[i][GlobalRes.Language]
		piece_scene.name = str(i)
		piece_scene.position = Vector2(536, 720 - 34  -48 * i )
		piece_scene.select_piece.connect(_select_piece)
		if(i == 0):
			GlobalRes.cur_piece_node = piece_scene
		$queue.add_child(piece_scene)
	array = []
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(GlobalRes.need_select_a_piece):
		if($queue.get_children().size() == 0):
			fill_select_area()
			fill_array()
			#print("fill")
		for node in $queue.get_children():
			$BrownFrame.position = node.position
			GlobalRes.cur_piece_node = node
			display_describe(node)
			GlobalRes.need_select_a_piece = false
		pass
	pass

func display_describe(node):
	var text = node.describe.replace("[x]","[" + str(node.base_value + node.lvup_value * node.level) + "]")
	$"../piece_describe".text = text

func _select_piece(name,id,level):
	var node = get_node("./queue/" + name)
	$BrownFrame.position = node.position
	GlobalRes.cur_piece_node = node
	#var piece_data = GlobalRes.piece_type_json[id]
	display_describe(node)
	pass
