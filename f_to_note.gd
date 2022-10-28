# https://pages.mtu.edu/~suits/NoteFreqCalcs.html

const a = pow(2.0, 1.0 / 12.0)
const A4 = 440 # Hz - middle C

const MIN_FREQ = 27.5
const MAX_FREQ = 14080

const NOTES = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']

class Note:
	var oct: int
	var note: String
	func _init(newOct, newNote):
		oct = newOct
		note = newNote
	func _to_string():
		return note + str(oct)

static func stepsFromMiddleCToNote(steps: int) -> Note:
	var oct = 4 + floor(steps / 8)
	var note_index = posmod(steps, 8)
	
	return Note.new(oct, NOTES[note_index])

static func freqToNote(freq) -> Note:
	assert(freq > MIN_FREQ, 'Frequency must be greater than 27.5Hz')
	assert(freq < MAX_FREQ, 'Frequency must be less than 14080Hz')

	# f(n) = f(0) * a^n
	# ln(fn) = ln(f0) + n ln(a)
	var n = (log(freq) - log(A4)) / log(a)
	var steps_from_middle_c = stepify(n, 1.0)
	return stepsFromMiddleCToNote(steps_from_middle_c)
