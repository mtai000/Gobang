extends Node2D

signal damage_animate_finish
var damage_value
# Called when the node enters the scene tree for the first time.
func _ready():
	$Health.text = str(GlobalRes.player_health) + "/" + str(GlobalRes.player_max_health)
	$Blood.max_value = GlobalRes.player_max_health
	$Blood.value = GlobalRes.player_health
	$PlayerAnimate.play("IDLE")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func attack_animate():
	
	pass


func _on_hurt_box_area_entered(area):
	#print("player hurt")
	var damage  = preload("res://Scene/damage_label_effect.tscn").instantiate()
	damage.damage_value = str(5)
	GlobalRes.player_health -= 5
	$Blood.value = GlobalRes.player_health
	$Blood.max_value = GlobalRes.player_max_health
	$Health.text = str(GlobalRes.player_health) + "/" + str(GlobalRes.player_max_health)
	add_child(damage)
	emit_signal("damage_animate_finish")
	pass # Replace with function body.
