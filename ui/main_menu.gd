extends Control

@onready var host_button: Button = $HBoxContainer/HostButton
@onready var join_button: Button = $HBoxContainer/JoinButton


func _ready() -> void:
	host_button.pressed.connect(_on_host_pressed)
	join_button.pressed.connect(_on_join_pressed)


func _on_host_pressed() -> void:
	print("Host button pressed")


func _on_join_pressed() -> void:
	print("Play button pressed")
