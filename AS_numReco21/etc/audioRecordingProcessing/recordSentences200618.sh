#!/bin/csh
# Display sentences one by one, and store audio files as wav/*.wav
# 18-JUN-2020

# Edit the following variables as appropriate
set lang	= AS
set sentenceList = numbers80_AS.txt
# Lines of above file are as follows (number tab sentence)
#001	shoony ek do teen chaar paanch che saath aat nou
set nsec	= 5	# Duration (seconds) of each speech file 
set sampFreq = 16000	# Sampling frequency (Hz)

if !(-d ./wav) mkdir wav
echo -n "Enter a single letter (M or F) indicating the gender of the speaker:"
set input = $<
set gender = ` echo $input | tr "[a-z]" "[A-Z]" `
echo -n "Enter the speaker Id (Ex: 5): "
set input = $<
set spkrId = `printf "%03d\n" $input`
echo -n "Enter the serial number (Ex: 11) of the first sentence to be recorded in this recording session: "
set n = $<
echo -n "Enter the number (Ex: 20) of sentences to be recorded in this recording session: "
set m = $<
@ last = $n + $m
@ last--
echo ""
echo "Sentences $n through $last will be recorded"
echo "At any time:"
echo "Enter  r  to re-record the current sentence"
echo "Enter  q  to quit (stop recording)"
set next = ""
while ($n <= $last) 	
  echo ""; echo ""		# 2 blank lines.
  head -$n $sentenceList | tail -1	#print "nth" (current value) line
  echo ""
  echo "Press ENTER key to start recording"
  set next = $< 	# record speech after the user presses "Enter"
  if ($next == "q") exit 1	# quit
  if ($next == "r") then 
    echo "repeat recording ------------------------"
    @ n--			#re-record the previous sentence
    head -$n $sentenceList | tail -1
    set next = $< 
  endif
# record for $nsec seconds with the sampling rate = 16000Hz,
#  16 bits of quantization, single channel (mono).
# store the speech data in a file in a directory called "wav"
#  under the current directory. Name of the file is constructed as 
  set sentId = `printf "%04d\n" $n`
  set fname = "wav/""$lang""$spkrId""$gender""$sentId"".wav"
  echo "recording begins ..."
  rec -q -r $sampFreq -b 16 -c 1 $fname trim 0 $nsec
  echo "recording ended.   Playing the recorded speech ..."
  play -q $fname
  @ n++ 		# increment the value of the variable n	
end

exit 0


