#!/bin/csh
# NAME OF THE FILE 	: data_recording batch.sh
# PURPOSE		: To run a program (Estimate_SNR_clipPercent_16000.exe) on all
#			wav files in a directory
# IN/OUT ARGUMENTS	: None
# INPUTs 		: None
# IMPLICIT INPUT  VARIABLES     : None
# IMPLICIT OUTPUT VARIABLES     : Wavefiles stored in .../data/18ENG/ directory.
# CALLED FUNCTIONS	:  None               
# AUTHOR		: Samudravijaya K (speech.iitg@gmail.com)
# DATE WRITTEN		: 11-MAR-2019 13-MAY-2017, NOV-2018
# PSUDO CODE		:
#
# Note: change baseDir, program and logFile as appropriate
#----------------------------------------------------------------------------

set baseDir = ~/data
set program = Estimate_SNR_clip_16000.exe
set logFile = log_$program.txt

cd $baseDir
if (-e $logFile) rm $logFile; touch $logFile
foreach ff (`ls *.wav`)
  $program $ff >> $logFile
end

# REVISION HISTORY	:


