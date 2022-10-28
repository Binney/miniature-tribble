extends Node2D

const FToNote = preload("res://f_to_note.gd")

var effect
var recording
var spectrum

func _ready():
	var idx = AudioServer.get_bus_index('VengaBus')
	effect = AudioServer.get_bus_effect(idx, 1)
	spectrum = AudioServer.get_bus_effect_instance(idx, 0)

func _on_RecordButton_pressed():
	if effect.is_recording_active():
		$PlayButton.disabled = false
		effect.set_recording_active(false)
		$RecordButton.text = "Record"
		recording = effect.get_recording()
	else:
		$PlayButton.disabled = true
		effect.set_recording_active(true)
		$RecordButton.text = "Stop"


func _on_PlayButton_pressed():
	print(recording)
	print(recording.format)
	print(recording.mix_rate)
	print(recording.stereo)
	var data = recording.get_data()
	print(data.size())
	$AudioStreamPlayer.stream = recording
	$AudioStreamPlayer.play()

const VU_COUNT = 50
const FREQ_MAX = 14080.0

const WIDTH = 400
const HEIGHT = 100

const MIN_DB = 60

var w = 20

func _draw():
	var hz = FToNote.A4
	var loudestMagnitudeYet = 0
	var bestNote = 0
	var loudestHz = 0
	for i in range(0, 48):
		var prev_hz = hz
		hz = prev_hz * FToNote.a
		var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clamp((MIN_DB + linear2db(magnitude)) / MIN_DB, 0, 1)
		var height = energy * HEIGHT
		draw_rect(Rect2(w * i, HEIGHT - height, w, height), Color.white)
		if magnitude > loudestMagnitudeYet:
			loudestMagnitudeYet = magnitude
			bestNote = i
			loudestHz = hz
	$Label.text = str(loudestHz) + 'Hz'
	$NoteLabel.text = FToNote.stepsFromMiddleCToNote(bestNote).to_string()

func _process(_delta):
	update()
