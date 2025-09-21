extends Node

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func register_buttons(buttons: Array):
	# Connect provided buttons to play the UI click sound.
	for button in buttons:
		button.pressed.connect(_on_button_pressed)


func _on_button_pressed():
	audio_stream_player.play()
