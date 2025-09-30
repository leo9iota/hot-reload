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

# Fade controls
@export var enable_fade: bool = true            # Enable volume ramp at loop boundary
@export var fade_time: float = 0.08             # Seconds to fade (40–120 ms works well)
@export var use_crossfade: bool = false         # Crossfade using a duplicate player

# Debug preview helpers (to audition the transition quickly)
@export var debug_preview_on_start: bool = false   # If true, jump near loop_end on start
@export var debug_preview_margin: float = 1.0      # How many seconds before loop_end to preview
@export var debug_enable_hotkey: bool = true       # Press an input action to preview
@export var debug_hotkey_action: StringName = &"ui_accept"

var _first_pass := true
var _base_volume_db: float = 0.0
var _fade_phase: int = 0     # 0=none, 1=fade_out, 2=fade_in
var _fade_t: float = 0.0
var _crossfade_active: bool = false
var _alt_player: AudioStreamPlayer

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

	_base_volume_db = game_music_player.volume_db

	# Optionally create an alternate player for crossfading
	if use_crossfade:
		_alt_player = AudioStreamPlayer.new()
		_alt_player.stream = game_music_player.stream
		_alt_player.bus = game_music_player.bus
		_alt_player.autoplay = false
		_alt_player.volume_db = -80.0
		add_child(_alt_player)

	# Start playback if not already started via Autoplay.
	if not game_music_player.playing:
		game_music_player.play()

	# If preview enabled, jump near the end right away to hear the transition
	if debug_preview_on_start:
		var end_time: float = loop_end
		if end_time <= 0.0 and game_music_player.stream:
			end_time = game_music_player.stream.get_length()
		if end_time > 0.0:
			var t: float = max(end_time - max(debug_preview_margin, 0.0), 0.0)
			game_music_player.seek(t)
	# When the first pass finishes (because built-in looping is off), restart at loop_start.
	game_music_player.finished.connect(_on_player_finished)

func _process(_dt: float) -> void:
	if not game_music_player.playing or _first_pass:
		return

	# Optional: debug hotkey to jump near loop_end instantly
	if debug_enable_hotkey and Input.is_action_just_pressed(debug_hotkey_action):
		var end_debug: float = loop_end
		if end_debug <= 0.0 and game_music_player.stream:
			end_debug = game_music_player.stream.get_length()
		if end_debug > 0.0:
			var tdebug: float = max(end_debug - max(debug_preview_margin, 0.0), 0.0)
			game_music_player.seek(tdebug)

	var end_time: float = loop_end
	if end_time <= 0.0 and game_music_player.stream:
		end_time = game_music_player.stream.get_length()

	if end_time <= 0.0:
		return

	var pos: float = game_music_player.get_playback_position()
	var fade_dur: float = max(fade_time, 0.0)

	# Crossfade path
	if enable_fade and use_crossfade and fade_dur > 0.0:
		# Start crossfade shortly before the loop end
		if not _crossfade_active and pos >= end_time - fade_dur:
			_crossfade_active = true
			if _alt_player:
				_alt_player.stop()
				_alt_player.stream = game_music_player.stream
				_alt_player.volume_db = -80.0
				_alt_player.play(loop_start)
		# Drive crossfade if active
		if _crossfade_active:
			var frac: float = clamp((pos - (end_time - fade_dur)) / max(fade_dur, 0.0001), 0.0, 1.0)
			game_music_player.volume_db = lerp(_base_volume_db, -80.0, frac)
			if _alt_player:
				_alt_player.volume_db = lerp(-80.0, _base_volume_db, frac)
			if pos >= end_time:
				# Swap roles: alt takes over as the main player
				game_music_player.stop()
				game_music_player.volume_db = _base_volume_db
				if _alt_player:
					var tmp: AudioStreamPlayer = game_music_player
					game_music_player = _alt_player
					_alt_player = tmp
					_alt_player.volume_db = -80.0
					_alt_player.stop()
				_crossfade_active = false
		return

	# Single-player fade in/out approach
	if enable_fade and fade_dur > 0.0:
		if _fade_phase == 0 and pos >= end_time - fade_dur:
			_fade_phase = 1
			_fade_t = 0.0
		if _fade_phase == 1:
			_fade_t += _dt
			var frac_out: float = clamp(_fade_t / fade_dur, 0.0, 1.0)
			game_music_player.volume_db = lerp(_base_volume_db, -80.0, frac_out)
			if pos >= end_time:
				game_music_player.seek(loop_start)
				_fade_phase = 2
				_fade_t = 0.0
				return
		elif _fade_phase == 2:
			_fade_t += _dt
			var frac_in: float = clamp(_fade_t / fade_dur, 0.0, 1.0)
			game_music_player.volume_db = lerp(-80.0, _base_volume_db, frac_in)
			if frac_in >= 1.0:
				_fade_phase = 0
				game_music_player.volume_db = _base_volume_db
			return

	# No fade: hard jump
	if pos >= end_time:
		game_music_player.seek(loop_start)

func _on_player_finished() -> void:
	# First pass completed: from now on we’ll loop between [loop_start, loop_end]
	_first_pass = false
	game_music_player.play(loop_start)
