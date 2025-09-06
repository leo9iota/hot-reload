extends CharacterBody2D


func _process(delta: float) -> void:
	velocity = movement_vector * 100
	move_and_slide()
