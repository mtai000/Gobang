extends Node2D

@onready var camera_border_y = 3400
var start_pos
var next_scene
var player_move_to_next_room
var target_pos
var step
var room_type_json : Dictionary
@onready var rooms_total_weight = 0
@onready var boss = $Boss
@onready var height_of_floor = 200
@onready var floor  = 15
@onready var player = $Player

@onready var endPosition
@onready var startPosition
var room_dict : Dictionary
var room_position_dict : Dictionary

@onready var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.seed = hash(GlobalRes.seed)
	room_tree()
	create_room_node()
	connect_rooms()
	$Player/Animate.play("IDLE")
	$Player.position = GlobalRes.player_position
	camera.position = Vector2(640 ,$Player.position.y - 200)
	GlobalRes.SaveGameInJson()
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(player_move_to_next_room and target_pos):
		player.position += step * delta
		if(player.position.distance_to(target_pos) < 10):
			player_move_to_next_room = false
			camera.position.y = target_pos.y
			GlobalRes.player_position = target_pos
			camera.map_position = camera.position
			camera.reset()
			get_tree().change_scene_to_file(next_scene)
	
	if(GlobalRes.player_health <= 0 ):
		$"..".queue_free()
	pass
	
func _input(event):
	if(event is InputEventMouseButton):
		var wheel_step = 25
		if(event.button_index == 4): #UP
			if(camera.position.y > 385):
				camera.position.y -= wheel_step
		elif(event.button_index == 5):  #DOWN
			if(camera.position.y < camera_border_y):
				camera.position.y += wheel_step
		if(event.button_index == 1):
			if(event.is_released()):
				var childs = $Path2D.get_children()
				var click_node
				for child in childs:
					var child_pos = get_node(child.get_path()).position
					if (abs(child_pos.x - event.position.x) < 30 and 
						abs(camera.position.y - 360 + event.position.y - child_pos.y) < 30):
						click_node = child
						break
				#print(event.position)
				if(click_node):
					if(click_node.position.y < $Player.position.y):
						var line = [click_node.position,$Player.position]
						#print(line in  $Path2D.draw_lines)
						if(line in  $Path2D.draw_lines):
							player_move_to_next_room = true
							target_pos = click_node.position
							
							step = (target_pos - $Player.position).normalized() * 300
							$Player/Animate.play("WALK")
							#print(target_pos)
							if(click_node.room_type == "chest_room"):
								pass
							if(click_node.room_type == "maintain_room"):
								pass
							if(click_node.room_type == "upgrade_room"):
								pass
							if(click_node.room_type == "monster_room"):
								next_scene = "res://Scene/battle.tscn"
							if(click_node.room_type == "elite_monster_room"):
								pass
							#print(click_node.room_type)
				


		
func room_tree():
	var bossDefaultPos = Vector2(640,200)
	boss.position = bossDefaultPos
	
	var playerDefaultPos = boss.position + Vector2(0 , height_of_floor) * (floor + 1)
	player.position = playerDefaultPos

	
	endPosition = boss.position
	startPosition = player.position
	var room_num_in_this_floor
	
	room_position_dict[0] = [endPosition]
	room_dict[0] = []
	for i in floor:
		if(i ==0 or i == floor - 1):
			room_num_in_this_floor = rng.randi() % 2 + 3
		else:
			room_num_in_this_floor = rng.randi() % 3 + 3
		
		var layer_point = []
		for j in room_num_in_this_floor:
			var x = camera.default_windows_size.x / (room_num_in_this_floor + 1 ) * ( j  + 1)
			var p = Vector2(x,height_of_floor * ( i + 1) + endPosition.y)
			#points.append(p)
			layer_point.append(p)
			
		room_position_dict[i + 1] = layer_point
		room_dict[i+1] = []
	
	room_position_dict[floor + 1] = [startPosition]
	room_dict[floor+1] = []
	
func random_room_type():
	var ran_cur = rng.randi_range(0,rooms_total_weight - 1) 
	var cur_weight = 0
	var selected_room
	for room_name in GlobalRes.room_type_json:
		cur_weight += GlobalRes.room_type_json[room_name]["weight"]
		if(ran_cur < cur_weight):
			selected_room = room_name
			break
		
	if(not selected_room):
		pass
	return selected_room

func create_room_node():
	for level in room_position_dict.size() - 1:
		for room_num in room_position_dict[level].size():
			var temp_room_node = preload("res://Scene/room_in_map_icon.tscn").instantiate()
			room_dict[level].append(temp_room_node)
			var room_name = random_room_type()
			if(level == 0):
				temp_room_node.room_type = "boss_room"
			elif(level == 8):
				temp_room_node.room_type= "chest_room"
				temp_room_node.image_path = GlobalRes.room_type_json["chest_room"]["icon"]
			else:
				temp_room_node.room_type = room_name
				temp_room_node.image_path = GlobalRes.room_type_json[room_name]["icon"]
				if(rng.randi() % 3 == 1):
					temp_room_node.image_path= GlobalRes.room_type_json["unknown_room"]["icon"]
			temp_room_node.name = str(Vector2(level,room_num))
			temp_room_node.position = room_position_dict[level][room_num]
			$Path2D.add_child(temp_room_node)
		

func connect_rooms():
	var interval = 0
	for level in room_position_dict.size() - 1:
	#for room_num in room_position_dict[level].size():
		var cur_level_interval = camera.default_windows_size.x/(room_position_dict[level].size() + 1)
		var next_level_interval = camera.default_windows_size.x/(room_position_dict[level + 1].size() + 1) 
		if(cur_level_interval == next_level_interval):
			for i in room_position_dict[level].size():
				$Path2D.draw_lines.append([room_position_dict[level][i],room_position_dict[level + 1][i]])
			
			for i in room_position_dict[level].size() - 1:
				var direct = [0,1]
				if(rng.randi()%2):
					direct = [1,0]
				if(rng.randi() % 2):
					$Path2D.draw_lines.append([room_position_dict[level][i + direct[0]],room_position_dict[level + 1][i + direct[1]]])
				pass
		#elif(cur_level_interval > next_level_interval):
		else:
			if(cur_level_interval > next_level_interval):
				interval = cur_level_interval
			else:
				interval = next_level_interval
			
			for i in room_position_dict[level + 1].size():
				for j in room_position_dict[level].size():
					var p1 =  room_position_dict[level + 1][i]
					var p2 = room_position_dict[level][j]
					if( abs(p1.x - p2.x) < interval - 10 ):
						$Path2D.draw_lines.append([p2,p1])
