extends CanvasLayer

@export var enemy_manager: EnemeyManager
@onready var timer_label: Label = %RoundTimerLabel
@onready var round_count_label: Label = %RoundCountLabel


func _process(_delta: float) -> void:
	timer_label.text = str(ceili(enemy_manager.get_round_time_remaining()))
