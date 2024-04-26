extends Node2D

var buff_dict : Dictionary
# Called when the node enters the scene tree for the first time.
func _ready():
	buff_dict["hits"] = 0
	set_buff_position()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_buff_position():
	for i in buff_dict.size():
		var node = get_children()[i]
		node.position = Vector2(68 * i + 24,24)
		node.texture = load("res://Asset/Buff/hits.png")
