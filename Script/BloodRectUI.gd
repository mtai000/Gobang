extends Node2D

@onready var blood = $blood
# Called when the node enters the scene tree for the first time.
func _ready():
	blood.size(32,220)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
