extends CanvasLayer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()
		get_viewport().set_input_as_handled()
		
		
func toggle_pause():
	visible = not visible
	get_tree().paused = visible
