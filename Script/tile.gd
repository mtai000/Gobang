extends Area2D

signal return_position(i,j)
var i_ind : int
var j_ind : int
signal blink_complete
# Called when the node enters the scene tree for the first time.
func _ready():
	$piece.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func blink():
	var blink_timer = Timer.new()
	var queue_timer = Timer.new()
	blink_timer.name = "blink_timer"
	queue_timer.name = "queue_timer"
	add_child(blink_timer)
	add_child(queue_timer)
	blink_timer.timeout.connect(_toggle_visibility)
	blink_timer.wait_time = 0.3
	blink_timer.start()
	queue_timer.timeout.connect(_blink_end)
	queue_timer.wait_time = 1.5
	queue_timer.start()

func _blink_end():
	$piece.texture = null
	GlobalRes.setGridValue(i_ind,j_ind,"0")
	GlobalRes.setGridDictArray(i_ind,j_ind,GlobalRes.piece_type_json["0"])
	$blink.stop()
	get_node("./blink_timer").queue_free()
	get_node("./queue_timer").queue_free()
	emit_signal("blink_complete")

func _on_input_event(viewport, event, shape_idx):
	if(GlobalRes.clickable and GlobalRes.board_status == GlobalRes.STATUS.PLACE_PIECE and GlobalRes.cur_user == GlobalRes.WHO.PLAYER):
		if(event.is_action_pressed("click")):
			print(GlobalRes.getGridValue(i_ind,j_ind))
			print(GlobalRes.getGridDictArray(i_ind,j_ind))
			if(GlobalRes.getGridValue(i_ind,j_ind) == "0"):
				var image_path = ""
				if(GlobalRes.cur_user == GlobalRes.WHO.PLAYER):
					image_path = GlobalRes.piece_type_json[GlobalRes.cur_piece_node.id]["path"]
				GlobalRes.setGridValue(i_ind,j_ind,GlobalRes.cur_piece_node.id)
				GlobalRes.setGridDictArray(i_ind,j_ind,GlobalRes.piece_type_json[GlobalRes.cur_piece_node.id])
			#if(GlobalRes.cur_user == GlobalRes.WHO.AI):
			#	image_path = GlobalRes.piece_type_json["-1"]["path"]
				$piece_capture.play()
				$piece.texture = load(image_path)
				$piece.visible = true
				emit_signal("return_position",i_ind,j_ind)
	pass # Replace with function body.

func aiSetTilePiece(piece_id,sil):
	if(str(piece_id) != "0"):
		set_image_path(GlobalRes.piece_type_json[str(piece_id)]["path"])
		GlobalRes.setGridValue(i_ind,j_ind,piece_id)
		GlobalRes.setGridDictArray(i_ind,j_ind,GlobalRes.piece_type_json[str(piece_id)])
		
		if(not sil):
			$piece_capture.play()
		$piece.visible = true
	pass

func _toggle_visibility():
	if($piece.visible):
		$blink.play()
		$piece.visible = false
	else:
		$piece.visible = true
		
func set_image_path(path):
	$piece.texture= load(path)

