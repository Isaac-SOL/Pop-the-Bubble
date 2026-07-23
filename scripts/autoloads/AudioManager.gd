extends Node

@onready var audio_stream_player_music: AudioStreamPlayer = $AudioStreamPlayer_music
@onready var audio_stream_player_ambiant: AudioStreamPlayer = $AudioStreamPlayer_ambiant
@onready var audio_stream_player_sfx: AudioStreamPlayer = $AudioStreamPlayer_sfx

var interactive_stream_music : AudioStreamPlaybackInteractive
var interactive_stream_ambiant : AudioStreamPlaybackInteractive
var interactive_stream_sfx : AudioStreamPlaybackInteractive

var playing_stream_music_clip_name : String
var playing_stream_ambiant_clip_name : String
var playing_stream_sfx_clip_name : String

#Store last clips for resuming
var last_stream1_clip : String
var last_stream2_clip : String

var pause := false

@export var transition_duration := 5.0



var alternative_is_playing := false
var init_volume_db: float
var tween: Tween


var timer := 0.0

func _process(delta):
	timer -= delta


func play_bubble_collision()-> void:
	#if timer > 0.0:
		#return
	timer = 0.05
	if randf() < 0.7: #70% luck to play sound
		playAudio_stream_sfx(&"bubble_collision")
	
		
			
func playAudio_stream_music(sound_name: String) -> void:
	#Start the AudioStreamPlayer if it isn't already playing
	if !audio_stream_player_music.playing:
		audio_stream_player_music.volume_db = -80
		audio_stream_player_music.play()

		#Wait one frame so the playback object is created
		await get_tree().process_frame

		interactive_stream_music = audio_stream_player_music.get_stream_playback() as AudioStreamPlaybackInteractive

		if interactive_stream_music:
			interactive_stream_music.switch_to_clip_by_name(sound_name)
			playing_stream_music_clip_name = sound_name
			audio_stream_player_music.volume_db = 0

	#Already playing: only switch clips if necessary
	else:
		var playback := audio_stream_player_music.get_stream_playback() as AudioStreamPlaybackInteractive

		if playback and playing_stream_music_clip_name != sound_name:
			playback.switch_to_clip_by_name(sound_name)
			playing_stream_music_clip_name = sound_name
			
			
func playAudio_stream_ambiant(sound_name: String) -> void:
	if !interactive_stream_ambiant:
		audio_stream_player_ambiant.volume_db = -80
		audio_stream_player_ambiant.play()
		await get_tree().process_frame  #Let audio backend catch up

		interactive_stream_ambiant = audio_stream_player_ambiant.get_stream_playback() as AudioStreamPlaybackInteractive
		if interactive_stream_ambiant:
			interactive_stream_ambiant.switch_to_clip_by_name(sound_name)
			playing_stream_ambiant_clip_name = sound_name
			audio_stream_player_ambiant.volume_db = 0

	#elif !pause and interactive_stream_ambiant:
	elif interactive_stream_ambiant:
		#Only switch if it's not already playing
		if playing_stream_ambiant_clip_name != sound_name:
			interactive_stream_ambiant.switch_to_clip_by_name(sound_name)
			playing_stream_ambiant_clip_name = sound_name
			

func playAudio_stream_sfx(sound_name: String) -> void:
	if !interactive_stream_sfx:
		audio_stream_player_sfx.volume_db = -80
		audio_stream_player_sfx.play()
		await get_tree().process_frame  #Let audio backend catch up
		interactive_stream_sfx = audio_stream_player_sfx.get_stream_playback() as AudioStreamPlaybackInteractive
		if interactive_stream_sfx:
			interactive_stream_sfx.switch_to_clip_by_name(sound_name)
			playing_stream_sfx_clip_name = sound_name
			audio_stream_player_sfx.volume_db = 0
		
	elif !pause and interactive_stream_sfx:
		interactive_stream_sfx.switch_to_clip_by_name(sound_name)
		playing_stream_sfx_clip_name = sound_name
		
		
func stopAudio_stream(audio_stream_player: AudioStreamPlayer) -> void:
	if audio_stream_player.playing:
		audio_stream_player.stop()
		
	
func pauseAudio() -> void:
	if pause:
		return

	audio_stream_player_music.stream_paused = true
	audio_stream_player_ambiant.stream_paused = true

	pause = true
		
func unpauseAudio() -> void:
	if !pause:
		return
	
	audio_stream_player_music.volume_db = -80
	audio_stream_player_ambiant.volume_db = -80
	audio_stream_player_music.stream_paused = false
	audio_stream_player_ambiant.stream_paused = false
	await get_tree().process_frame
	audio_stream_player_music.volume_db = 0
	audio_stream_player_ambiant.volume_db = 0

	pause = false


func fade_out(audio_stream_player: AudioStreamPlayer) -> void:		
	#Tween music volume down to -60
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	init_volume_db = audio_stream_player.volume_db
	# Wait for the tween to complete
	tween.tween_property(audio_stream_player, "volume_db", -60, transition_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

	#When the tween ends, the music will be stopped
	await tween.finished
	#Stop audio_stream_player and reset volume
	audio_stream_player.stop()
	audio_stream_player.volume_db = init_volume_db

func get_associated_interactive_stream(audio_stream_player: AudioStreamPlayer) -> AudioStreamPlaybackInteractive:
	match audio_stream_player:
		audio_stream_player_music:
			return interactive_stream_music
		audio_stream_player_ambiant:
			return interactive_stream_ambiant
		audio_stream_player_sfx:
			return interactive_stream_sfx
	return null
	
func get_associated_playing_clip_name(audio_stream_player: AudioStreamPlayer) -> String:
	match audio_stream_player:
		audio_stream_player_music:
			return playing_stream_music_clip_name
		audio_stream_player_ambiant:
			return playing_stream_ambiant_clip_name
		audio_stream_player_sfx:
			return playing_stream_sfx_clip_name
	return ""
