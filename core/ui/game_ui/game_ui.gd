class_name GameUI extends CanvasLayer

@export var enemy_manager: EnemyManager
@onready var round_timer_label: Label = %RoundTimerLabel
@onready var round_count_label: Label = %RoundCountLabel
@onready var health_bar: ProgressBar = %HealthBar
@onready var username_label: Label = %UsernameLabel


func _ready() -> void:
	enemy_manager.round_changed.connect(_on_round_began)


func _process(_delta: float) -> void:
	round_timer_label.text = str(
		ceili(enemy_manager.get_round_time_remaining())
	)


func connect_player(player: Player):
	(
		(func():
			if multiplayer.multiplayer_peer is OfflineMultiplayerPeer:
				username_label.text = "Player"
			else:
				username_label.text = player.username

			player.health_component.health_changed.connect(_on_health_changed)
			_on_health_changed(
				player.health_component.current_health,
				player.health_component.max_health
			))
		. call_deferred()
	)


func _on_round_began(round_count: int):
	round_count_label.text = ("Round %s" % round_count)


func _on_health_changed(current_health: int, max_health: int):
	health_bar.value = (
		(float(current_health) / float(max_health)) if max_health != 0 else 0.0
	)
