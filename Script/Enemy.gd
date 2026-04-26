extends Node2D


var health
var max_health = 5
var enemy_id : String

signal damage_animate_finish
signal select_enemy(node)

var poison_debuff : int = 0
var armor : int = 0
var hits : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#position = Vector2(640,360)
	health = max_health
	$Blood.max_value = max_health
	$Blood.value = health
	$EnemyAnimate.flip_h = true
	$Label.text = str($Blood.value)+"/"+str($Blood.max_value)
	if(enemy_id):
		$EnemyAnimate.play("enemy_" + enemy_id + "_idle")
	
	return
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_selected_enemy_input_event(viewport, event, shape_idx):
	if(event.is_action_pressed("click")):
		emit_signal("select_enemy",self)
		pass
	pass # Replace with function body.


func _on_hurt_box_area_entered(area):
	print("enemy hurt")
	var damage  = preload("res://Scene/damage_label_effect.tscn").instantiate()
	var value = 30
	damage.damage_value = str(value)
	$Blood.value -= value
	$Label.text = str($Blood.value)+"/"+str($Blood.max_value)
	add_child(damage)
	emit_signal("damage_animate_finish")
	
	#print("Hurted")
	pass # Replace with function body.
