extends Path2D

@export var draw_lines = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	for line in draw_lines:
		var p1 = line[0]
		var p2 = line[1]
		var gap= (p2-p1).normalized() * 40
		draw_line(p1 + gap, p2 - gap,Color(1.0,1.0,1.0),3)
