extends Area2D

var image_path
@export var id : String
var index
var level = 1
var base_value : int
var lvup_value : int
var describe : String
signal select_piece(name,id,level)
# Called when the node enters the scene tree for the first time.
func _ready():
	set_texture()
	$Label.text = str(level)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(position.y < 200 or position.y > 720 - 24):
		visible = false
	else:
		visible = true
	pass

func set_texture():
	if(id and id!=""):
		var piece = GlobalRes.piece_type_json[id]
		var texture = load(piece["path"])
		if (texture):
			$Sprite2D.texture = texture
			#var sprite = Sprite2D.new()
			#sprite.texture = texture
			#sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			#add_child(sprite)

func _on_input_event(viewport, event, shape_idx):
	if(event.is_action_pressed("click")):
		emit_signal("select_piece",name,id,level)
	pass # Replace with function body.
