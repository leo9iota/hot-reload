extends CanvasLayer

@export var enemy_manager: EnemyManager
@onready var round_timer_label: Label = %RoundTimerLabel
@onready var round_count_label: Label = %RoundCountLabel


func _ready() -> void:
	enemy_manager.round_changed.connect(_on_round_began)


func _process(_delta: float) -> void:
	round_timer_label.text = str(ceili(enemy_manager.get_round_time_remaining()))


func _on_round_began(round_count: int):
	round_count_label.text = "Round %s" % round_count
