extends Node

@onready var button_stream_player: AudioStreamPlayer = $ButtonStreamPlayer

static var instance: UIAudioManager


func _ready() -> void:
	instance = self


static func register_buttons(buttons: Array):
	for button in buttons:
		button.pressed.connect(instance._on_button_pressed)


func _on_button_pressed():
	instance.button_stream_player.play()
