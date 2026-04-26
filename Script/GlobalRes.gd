extends Node

#var playerPiecesQueue : Array
var playerPieceDictArray : Array

var player_health : int
var player_max_health : int

var treasure : Array
var current_map : int
var current_player_position : Vector2

var seed : String
var board_array : Array
var board_dict_array : Array

var map_id : int

var tree_map_camera_position : Vector2i
var player_position : Vector2i
#var b_explorer_map : bool
var tile_nums = 14

var json_parse

var room_type_json
var piece_type_json
var treasure_type_json

var rooms_total_weight : int
const continue_scene ="res://Saved/_saved.tscn"
var clickable : bool

var cur_user : WHO
var queue_size : int

var cur_piece_node : Node2D
var need_select_a_piece : bool
var board_status : STATUS

var treasureArray:Array

var piece_total_weight : int
var treasure_total_weight : int
var Language : String = "cn"

@onready var rng = RandomNumberGenerator.new()

enum STATUS {
	PLACE_PIECE,
	CHECK_FIVE_IN_ROW,
	WAIT_BLINK_COMPLETE,
	WAIT_ATTACK_ANIMATE_COMPLETE,
	WAIT_DAMAGE_ANIMATE_COMPLETE,
	ANYONE_IS_DEAD
}

enum WHO {
	PLAYER,
	AI
}

func switch_current_player():
	if(cur_user == WHO.AI):
		#print("switch to player")
		cur_user = WHO.PLAYER
	else:
		#print("switch to ai")
		cur_user = WHO.AI


func _ready():
	load_config()
	GlobalRes.board_array.resize(tile_nums * tile_nums)
	GlobalRes.board_dict_array.resize(tile_nums * tile_nums)
	GlobalRes.board_array.fill("0")
	tree_map_camera_position = Vector2(0,0)
	queue_size = 3
	
func add_a_piece(id,level):
	id = str(id)
	var d : Dictionary
	for i in piece_type_json[id]:
		d[i] =  piece_type_json[id][i]
	d["level"] = level
	#playerPiecesQueue.append(id)
	playerPieceDictArray.append(d)
	pass
	#importPiecesData()
	'''
func importPiecesData():
	var piece : Dictionary
	for p in piece_type_json:
		piece["ID"] = p["ID"]
		piece["Image_Path"] = p["image_path"]
		piece["Max_Level"] = p["max_level"]
		piece["Level"] = 1
		print(piece)
	pass
'''
func SaveCurrentGameStatus():
	DirAccess.make_dir_absolute("res://Saved")
	
	var packed_scene = PackedScene.new()
	packed_scene.pack(get_tree().current_scene)
	ResourceSaver.save(packed_scene,continue_scene)
	
	pass

func SaveGameInJson():
	var dict : Dictionary
	var file = FileAccess.open("res://Saved/_save.json",FileAccess.WRITE)
	dict["seed"] = seed
	dict["playerPieceDictArray"] = playerPieceDictArray
	dict["treasureArray"] = treasureArray
	dict["player_position"] = player_position
	dict["player_health"] = player_health
	dict["player_max_health"] = player_max_health
	var json_string = JSON.stringify(dict)
	file.store_line(json_string)
	
func ContinueLastGame():
	get_tree().change_scene_to_file(continue_scene)
	
func SavePlayerData():
	pass
	
func load_config():
	var json_path = "res://Asset/config.json"	
	var json_text = FileAccess.get_file_as_string(json_path)
	json_parse = JSON.parse_string(json_text)
	
	piece_type_json = json_parse["pieces"]
	room_type_json = json_parse["roomtype"]
	treasure_type_json = json_parse["treasure"]
	for room_name in room_type_json:
		rooms_total_weight += room_type_json[room_name]["weight"]
	for piece_name in piece_type_json:
		piece_total_weight += piece_type_json[piece_name]["weight"]
	for treasure_name in treasure_type_json:
		treasure_total_weight += treasure_type_json[treasure_name]["weight"]
	pass

func setGridValue(row,col,value):
	GlobalRes.board_array[col * tile_nums + row] = value

func setGridDictArray(row,col,node):
	GlobalRes.board_dict_array[col * tile_nums + row] = node

func array_pos_to_vec(i):
	return Vector2(i / tile_nums, i % tile_nums)

func getGridValue(row,col):
	return	GlobalRes.board_array[col * tile_nums + row]

func getGridDictArray(row,col):
	return GlobalRes.board_dict_array[col * tile_nums + row]
