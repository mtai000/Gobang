extends Node2D


var json_dict
@onready var aiSelectFrame = $"../aiSelectFrame"
@onready var piecesSelectAreaTilesNum = 1
@onready var ai_calculator = Calculator.new()
const aiFrame_default:Vector2 = Vector2(608,48)
var aiFrame_current : Vector2
var pieces_array
@onready var thread_ai :Thread = Thread.new()
@onready var thread_idle_ai : bool = true

@onready var thread_row : Thread = Thread.new()
@onready var thread_idle_row : bool = true
var bestPoint: Vector2 = Vector2(-1,-1) 

var row_points = null 
#var total_health : int
# Called when the node enters the scene tree for the first time.
func _ready():
	#print("PieceArraySize = " + str(GlobalRes.playerPieceDictArray.size()))
	aiSelectFrame.position = aiFrame_default + Vector2(6,6) * 48
	generate_board()
	ai_calculator.setMaxDepth(2)
	ai_calculator.setNear(1)
	$"../piecesSelectArea/ColorRect".position = Vector2(512,658 + 48) - Vector2(0,48) * GlobalRes.queue_size
	
	GlobalRes.board_status = GlobalRes.STATUS.PLACE_PIECE
	GlobalRes.cur_user = GlobalRes.WHO.PLAYER
	$"../Player".damage_animate_finish.connect(_damage_animate_finish)
	initiateEnemies()
	
	
	pass # Replace with function body.

func initiateEnemies():
	var total = (3400 - GlobalRes.player_position.y) / 40 + 25
	$"../EnemyGroup/Enemy".max_health = total
	$"../EnemyGroup/Enemy".scale = Vector2(4,4)
	$"../EnemyGroup/Enemy".enemy_id = "%02d" % (GlobalRes.rng.randi()%6 + 1)
	$"../EnemyGroup/Enemy".position = Vector2(400,120)
	$"../EnemyGroup/Enemy".damage_animate_finish.connect(_damage_animate_finish)
	
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(bestPoint)
	if(GlobalRes.board_status == GlobalRes.STATUS.PLACE_PIECE):
		#print("Place_piece")
		if(GlobalRes.cur_user == GlobalRes.WHO.AI):
			GlobalRes.clickable = false
			#print("AI")
			if($"../EnemyGroup".get_children().size() > 0):
				if(thread_idle_ai):
					GlobalRes.cur_user == GlobalRes.WHO.PLAYER
					#ai_calculator_best_position()
					bestPoint = Vector2(-1,-1)
					thread_ai.start(ai_calculator_best_position)
					thread_idle_ai = false
				if(bestPoint != Vector2(-1,-1)):
					thread_ai.wait_to_finish()
					#print(bestPoint)
					setAiSelectFramePosition(bestPoint)
					setTilePiece(bestPoint,"-1")
					thread_idle_ai = true
					
					#GlobalRes.cur_user = GlobalRes.WHO.PLAYER
				else:
					var icon_vec = Vector2i(randi() % GlobalRes.tile_nums,randi() % GlobalRes.tile_nums)
					setAiSelectFramePosition(icon_vec)
			pass
		else:
			GlobalRes.clickable = true
	elif(GlobalRes.board_status == GlobalRes.STATUS.WAIT_BLINK_COMPLETE):
		pass#print("wait blink complete then play attack animate")
	elif(GlobalRes.board_status == GlobalRes.STATUS.CHECK_FIVE_IN_ROW):
		bOneShot = true
		#print(thread_idle_row)
		if(thread_idle_row):
			thread_idle_row = false
			thread_row.start(check_five_in_a_row)
		elif(row_points != null):	
			thread_row.wait_to_finish()
			thread_idle_row = true
			if(row_points == []):
				GlobalRes.switch_current_player()
				GlobalRes.board_status = GlobalRes.STATUS.PLACE_PIECE
			else:
				print(row_points)
				var rp = row_points
				row_points = null
				queue_pieces(rp)
	elif(GlobalRes.board_status == GlobalRes.STATUS.WAIT_ATTACK_ANIMATE_COMPLETE):
		pass#print("wait attack animate complete then play damage animate")
	elif(GlobalRes.board_status == GlobalRes.STATUS.WAIT_DAMAGE_ANIMATE_COMPLETE):
		pass#_print("wait damege animate complete then switch to place piece")
	
	if(GlobalRes.board_status != GlobalRes.STATUS.ANYONE_IS_DEAD):
		if($"../EnemyGroup/Enemy/Blood".value <= 0):
			GlobalRes.board_status = GlobalRes.STATUS.ANYONE_IS_DEAD
			var select_reward_pieces = preload("res://Scene/select_reward_piece.tscn").instantiate()
			select_reward_pieces.z_index = 1
			$"..".add_child(select_reward_pieces)
		if(GlobalRes.player_health <= 0):
			GlobalRes.board_status = GlobalRes.ANYONE_IS_DEAD
			$"..".queue_free()
		
func setTilePiece(vec, piece_id):
	var n = get_node("./"+ str(vec))
	n.aiSetTilePiece(piece_id,false)
	GlobalRes.board_status = GlobalRes.STATUS.CHECK_FIVE_IN_ROW

func check_five_in_a_row():
	var vec = getAiSelectFramePosition()
	ai_calculator.updateArray2D(GlobalRes.board_array)
	var pointArray = ai_calculator.checkLink(vec.x,vec.y)
	row_points = []
	if(pointArray.size() > 0):
		for i in range(0,pointArray.size()/2):
			var v = Vector2i(pointArray[2*i],pointArray[2*i+1])
			if(not vec in row_points):
				row_points.append(v)

func _damage_animate_finish():
	GlobalRes.switch_current_player()
	GlobalRes.board_status = GlobalRes.STATUS.PLACE_PIECE
	print("damage animate complete , then return to place piece status")
	print(GlobalRes.board_status)
	pass

var bOneShot = true
func attack_animate():
	if(bOneShot):
		if(GlobalRes.cur_user == GlobalRes.WHO.PLAYER):
			var attack_scene = preload("res://Scene/attack.tscn").instantiate()
			attack_scene.attack_complete.connect(_attack_animate_complete)
			attack_scene.direction = 1
			$"../Player".add_child(attack_scene)
			#print("player attack animate")
		else:
			for enemy in $"../EnemyGroup/".get_children():
				var attack_scene = preload("res://Scene/attack.tscn").instantiate()
				attack_scene.attack_complete.connect(_attack_animate_complete)
				attack_scene.direction = -1
				enemy.add_child(attack_scene)
				#print("enemy attack animate")
		bOneShot = false
	
		GlobalRes.board_status = GlobalRes.STATUS.WAIT_ATTACK_ANIMATE_COMPLETE
		pass

func _attack_animate_complete():
	bOneShot = true
	print("attack animate complete , then waiting damage animate complete")

func queue_pieces(vec_array):
	var erase_count = 0
	GlobalRes.board_status = GlobalRes.STATUS.WAIT_BLINK_COMPLETE
	for vec in vec_array:
		var node  = get_node("./" + str(vec))
		if(node.name == "2"):
			erase_count += 1
		node.blink()
	
	
	
	if(GlobalRes.cur_user == GlobalRes.WHO.PLAYER):
		for t in GlobalRes.treasureArray:
			if(t.name == "1"):
				erase_count += 1
	
	var b = []
	while(erase_count > 0):
		var pos = randi() % (GlobalRes.tile_nums * GlobalRes.tile_nums)
		if(GlobalRes.board_array[pos] == "-1" and (not pos in b)):
			var node  = get_node("./" + str(GlobalRes.array_pos_to_vec(pos)))
			node.blink()
			b.append(pos)
			erase_count -= 1
	pass

func _blink_complete():
	print("blink animate complete , then execute attack animate")
	attack_animate()
	pass

func generate_board():
	for i in GlobalRes.tile_nums:
		for j in GlobalRes.tile_nums:
			var subScene = preload("res://Scene/tile.tscn").instantiate()
			subScene.position = Vector2(608,48) + Vector2(i,j) * 48
			subScene.name = str(Vector2(i,j))
			subScene.i_ind = i
			subScene.j_ind = j
			add_child(subScene)
			subScene.return_position.connect(_tile_return)
			subScene.blink_complete.connect(_blink_complete)
			subScene.aiSetTilePiece(GlobalRes.getGridValue(i,j),true)

func setAiSelectFramePosition(vec):
	aiSelectFrame.position = aiFrame_default + Vector2(vec) * 48
	aiFrame_current = aiSelectFrame.position

func getAiSelectFramePosition():
	return (aiFrame_current - aiFrame_default)/48

func _tile_return(i_index,j_index):
	setAiSelectFramePosition(Vector2(i_index,j_index))
	GlobalRes.cur_piece_node.queue_free()
	GlobalRes.need_select_a_piece = true
	GlobalRes.board_status = GlobalRes.STATUS.CHECK_FIVE_IN_ROW


func ai_calculator_best_position():
	var isEnemy = false
	if( GlobalRes.cur_user == GlobalRes.WHO.AI):
		isEnemy = true
	bestPoint = ai_calculator.searchBestPosition(GlobalRes.board_array,GlobalRes.tile_nums,isEnemy)
	
	


