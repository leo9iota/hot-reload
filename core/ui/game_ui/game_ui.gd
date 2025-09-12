extends CanvasLayer

@export var enemy_manager: EnemeyManager
@onready var timer_label: Label = %TimerLabel


func _process(_delta: float) -> void:
	timer_label.text = str(enemy_manager.get_round_time_remaining())
