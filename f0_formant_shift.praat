form Create manipulated files
   sentence Sound_file_extension .wav
   comment Directory path of input files:
   text input_directory D:\Lauri\notch_data\2021_avoid_manipulations\original_modal\male\
   comment Directory path of output files:
   text output_directory D:\Lauri\notch_data\2021_avoid_manipulations\
   comment Pitch settings (70/140-400/500)(90/160-500/600):
   positive Minimum_pitch 70
   positive Maximum_pitch 400
   positive Pitch_shift 0.15
   comment Formant settings(5000/5500-5250/5750):
   positive Max_formant 5000
endform

Create Strings as file list... list 'input_directory$'*'sound_file_extension$'
numberOfFiles = Get number of strings
for ifile to numberOfFiles
	select Strings list
	sound$ = Get string... ifile
	Read from file... 'input_directory$''sound$'
	objectname$ = selected$ ("Sound", 1)

	# Pitch shift
	noprogress To Manipulation: 0.01, minimum_pitch, maximum_pitch
	Extract pitch tier
	mean_p = Get mean (curve): 0, 0
	pitchshift = mean_p*pitch_shift
	Shift frequencies: 0, 1000, pitchshift, "Hertz"
	select Manipulation 'objectname$'
	plus PitchTier 'objectname$'
	Replace pitch tier
	select Manipulation 'objectname$'
	Get resynthesis (overlap-add)
	# save pitch15
	Rename: "f0_15"
	nowarn Save as WAV file: "'output_directory$''objectname$'_f015.wav"

	# f0 and Formant shift
	noprogress To Formant (burg): 0, 5, max_formant, 0.025, 50
	f1 = Get mean: 1, 0, 0, "hertz"
	f2 = Get mean: 2, 0, 0, "hertz"
	f3 = Get mean: 3, 0, 0, "hertz"
	select Sound f0_15
	noprogress runScript: "C:\Users\lauri\Praat\plugin_VocalToolkit\changeformants.praat", f1*1.10, f2*1.10, f3*1.10, 0, 0, max_formant, "no", "yes"
	nowarn Save as WAV file: "'output_directory$''objectname$'_f015_formant10.wav"

	# only formant shift
	select Sound 'objectname$'
	runScript: "C:\Users\lauri\Praat\plugin_VocalToolkit\changeformants.praat", f1*1.10, f2*1.10, f3*1.10, 0, 0, max_formant, "no", "yes"
	nowarn Save as WAV file: "'output_directory$''objectname$'_formant10.wav"
	
	# Remove
	select all
	minusObject: "Strings list"
	Remove
endfor