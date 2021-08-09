#######################################################################################################
#
# This Praat script will manipulate pitch curves based on coefficient tables.
# Please remember to add correct paths for sound files.
#
# Lauri Tavi 2020
#
#######################################################################################################

form Manipulate pitch
   	sentence Sound_file_extension .wav
   	comment Directory path of signals:
   	text signal_directory C:\..\
   	comment Directory path of coefficient tables:
   	text coeff_directory C:\...\
   	comment Directory path of output files:
   	text output_directory C:\\
	comment Pitch settings (65/550):
  	positive Minimum_pitch 65
  	positive Maximum_pitch 550
endform


# Name the coef file!
Read Table from whitespace-separated file: "C:\\pca_coefficients.txt"
c_table$ = selected$ ("Table", 1)
Down to Matrix

select Table 'c_table$'
n_rows = Get number of rows
row_val = 1

for f to n_rows
	select Table 'c_table$'
	filename$ = Get value: f, "file"
	Read from file... 'signal_directory$''filename$'
	# get the name of the sound object and create pitch object:
	soundname$ = selected$ ("Sound", 1)
	dur = Get total duration

	# get start and end time of pitch.
	select Sound 'soundname$'
	# VAD
	textgrid = To TextGrid (silences): 100, 0, -25, 0.025, 0.05, "silent", "sounding"
	n_intrvals = Get number of intervals: 1
	int_label$ = Get label of interval: 1, 1
	if int_label$ = "silent"
		start_pitch = Get end time of interval: 1, 1
	else
		start_pitch = Get start time of interval: 1, 1
	endif
	end_pitch = Get start time of interval: 1, n_intrvals

	# create modified pitch tier
	Create PitchTier: "m_pitch", 0, dur
	select PitchTier m_pitch
	time_t = end_pitch - start_pitch
	time_step = time_t / 202
	timing = start_pitch

	for i to 202
		if i > 1
			select Matrix pca_coefficients
			coef = Get value in cell: row_val, i
			select PitchTier m_pitch
			Add point: timing, coef
			timing = timing + time_step
		endif
	endfor

	row_val = row_val + 1

	# Create modified signal
	select Sound 'soundname$'
	noprogress To Manipulation: 0.01, minimum_pitch, maximum_pitch
	select PitchTier m_pitch
	plus Manipulation 'soundname$'
	Replace pitch tier
	select Manipulation 'soundname$'
	Get resynthesis (overlap-add)
	new_name$ = soundname$ + "_mod"
	Rename: new_name$

	mod_sound$ = soundname$+"_mod"
	select Sound 'mod_sound$'
	nowarn Save as WAV file: "'output_directory$''soundname$'_fdaf0.wav"

	# Clean
	select all
	minusObject: "Matrix pca_coefficients"
	minusObject: "Table pca_coefficients"
	Remove
endfor

select all
Remove