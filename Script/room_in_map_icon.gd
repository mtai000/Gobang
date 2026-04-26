extends Node2D

var image_path
var level
var room_type
# Called when the node enters the scene tree for the first time.
func _ready():
	if(image_path):
		var texture = load(image_path)
		if (texture):
			var sprite = Sprite2D.new()
			sprite.texture = texture
			sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			sprite.scale = Vector2(2,2)
			add_child(sprite)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_input_event(viewport, event, shape_idx):
	#print(event)
	pass # Replace with function body.
