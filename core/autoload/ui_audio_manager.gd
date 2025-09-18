extends Node

@onready var button_stream_player: AudioStreamPlayer = $ButtonStreamPlayer


func register_buttons(buttons: Array):
	for button in buttons:
		if not button.pressed.is_connected(_on_button_pressed):
			button.pressed.connect(_on_button_pressed)


func _on_button_pressed():
	button_stream_player.play()
