extends MultiplayerSynchronizer

var movement_vector: Vector2 = Vector2.ZERO


func _process(_delta: float) -> void:
	if is_multiplayer_authority():
		get_input()


func get_input():
	movement_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
