extends CharacterBody2D


const SPEED = 300.0
var direction = 1
signal attack_complete
func _ready():
	$AnimatedSprite2D.play("default")
	if(direction < 0):
		$HitBox.position = Vector2(-5,0)
		$AnimatedSprite2D.position = Vector2(-5,0)
		$AnimatedSprite2D.flip_h = true
		$HitBox.set_collision_mask_value(1,true)
		$HitBox.set_collision_mask_value(2,false)
		$HitBox.set_collision_layer_value(3,false)
		$HitBox.set_collision_layer_value(4,true)
	else:
		$HitBox.position = Vector2(5,0)
		$AnimatedSprite2D.position = Vector2(5,0)
		$AnimatedSprite2D.flip_h = false
		$HitBox.set_collision_mask_value(1,false)
		$HitBox.set_collision_mask_value(2,true)
		$HitBox.set_collision_layer_value(3,true)
		$HitBox.set_collision_layer_value(4,false)
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_hit_box_area_entered(area):
	$AnimatedSprite2D.play("hit")
	pass # Replace with function body.


func _on_animated_sprite_2d_animation_finished():
	emit_signal("attack_complete")
	queue_free()
	pass # Replace with function body.
