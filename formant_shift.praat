########################################################################################
#
# Modify formants. Please remember to add correct paths for sound files and 
# \plugin_VocalToolkit\changeformants.praat
# Lauri Tavi 2021
#
########################################################################################


form Create manipulated files
   sentence Sound_file_extension .wav
   comment Directory path of input files:
   text input_directory C:\\
   comment Directory path of output files:
   text output_directory C:\\
   comment Formant settings(5250):
   positive Max_formant 5250
endform

Create Strings as file list... list 'input_directory$'*'sound_file_extension$'
numberOfFiles = Get number of strings
for ifile to numberOfFiles
	select Strings list
	sound$ = Get string... ifile
	Read from file... 'input_directory$''sound$'
	objectname$ = selected$ ("Sound", 1)

	# Formant shift
	noprogress To Formant (burg): 0, 5, max_formant, 0.025, 50
	f1 = Get mean: 1, 0, 0, "hertz"
	f2 = Get mean: 2, 0, 0, "hertz"
	f3 = Get mean: 3, 0, 0, "hertz"

	select Sound 'objectname$'

	# Directory for VocalToolkit
	noprogress runScript: "C:\\plugin_VocalToolkit\changeformants.praat", f1*1.2, f2*1.2, f3*1.2, 0, 0, max_formant, "no", "yes"
	nowarn Save as WAV file: "'output_directory$''objectname$'_F-20.wav"
	
	# Remove
	select all
	minusObject: "Strings list"
	Remove
endfor