extends Node

# Use a uniquely named child node (Mark the AudioStreamPlayer as "Unique Name" and name it GameMusicPlayer),
# then the % shorthand will resolve anywhere within the scene.
@onready var game_music_player: AudioStreamPlayer = %GameMusicPlayer

# Loop window configuration (tweak in the Inspector)
# - loop_start: where to jump back to when we hit loop_end
# - loop_end:   where to cut playback (0 = use full stream length)
# - cut_tail_on_first_play: if true, enforce the loop window even on the very first pass
@export var loop_start: float = 0.0
@export var loop_end: float = 0.0
@export var cut_tail_on_first_play: bool = true

var _first_pass := true

func _ready() -> void:
	# Ensure stream-level looping is disabled so our custom range works.
	var s: AudioStream = game_music_player.stream
	if s:
		if s is AudioStreamOggVorbis:
			(s as AudioStreamOggVorbis).loop = false
		elif s is AudioStreamWAV:
			(s as AudioStreamWAV).loop_mode = AudioStreamWAV.LOOP_DISABLED

	# Decide whether to enforce loop window immediately.
	_first_pass = not cut_tail_on_first_play

	# Start playback if not already started via Autoplay.
	if not game_music_player.playing:
		game_music_player.play()
	# When the first pass finishes (because built-in looping is off), restart at loop_start.
	game_music_player.finished.connect(_on_player_finished)

func _process(_dt: float) -> void:
	if not game_music_player.playing or _first_pass:
		return

	var end_time := loop_end
	if end_time <= 0.0 and game_music_player.stream:
		end_time = game_music_player.stream.get_length()

	if end_time > 0.0 and game_music_player.get_playback_position() >= end_time:
		# Jump back to the loop start, skipping the quiet tail.
		game_music_player.seek(loop_start)

func _on_player_finished() -> void:
	# First pass completed: from now on we’ll loop between [loop_start, loop_end]
	_first_pass = false
	game_music_player.play(loop_start)
