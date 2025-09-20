class_name GameUI extends CanvasLayer

@export var enemy_manager: EnemyManager
@onready var round_timer_label: Label = %RoundTimerLabel
@onready var round_count_label: Label = %RoundCountLabel
@onready var health_bar: ProgressBar = %HealthBar
@onready var username_label: Label = %UsernameLabel
@onready var ready_label: Label = %ReadyLabel
@onready var not_ready_label: Label = %NotReadyLabel
@onready var ready_count_label: Label = %ReadyCountLabel
@onready var ready_up_container: VBoxContainer = %ReadyUpContainer
@onready var round_info_container: VBoxContainer = %RoundInfoContainer

@export var lobby_manager: LobbyManager


func _ready() -> void:
	enemy_manager.round_changed.connect(_on_round_began)
	lobby_manager.self_peer_ready.connect(_on_self_peer_ready)
	lobby_manager.lobby_closed.connect(_on_lobby_closed)
	
	ready_up_container.visible = true
	round_info_container.visible = false
	ready_label.visible = false
	not_ready_label.visible = true
	
	
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


func _on_self_peer_ready():
	ready_label.visible = true
	not_ready_label.visible = false
func _on_lobby_closed():
	ready_up_container.visible = false
	round_info_container.visible = true
