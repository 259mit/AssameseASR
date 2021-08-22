#!/bin/csh
# NAME OF THE FILE 	: machinename::path
# PURPOSE		: To write Kaldi transcription file for ../*.wav files
#			  
# INPUT ARGUMENTS	: Text file containing sentences preceded by serial numbers
# OUTPUT ARGUMENTS	: none
# IMPLICIT INPUT  VARIABLES     : none
# IMPLICIT OUTPUT VARIABLES     : "text": transcriptions in Kaldi format.
# IMPLICIT IN and OUT VARIABLES : 
# CALLED FUNCTIONS	:  None               
# AUTHOR		: Samudravijaya K (speech.iitg@gmail.com)
# DATE WRITTEN		: 20-APR-2020 <- 25-MAY-2018 
# PSUDO CODE		:
#----------------------------------------------------------------------------
if ($#argv < 1) then
 echo "Usage  : $0 inSentenceList"
 echo "Example: $0 AssameseSent.txt"
 exit 1
endif

set inFile = $1
alias rmtouch		'if (-e \!*) rm \!*; touch \!*'
rmtouch text
foreach ff (`ls ../wav/*.wav`)
  echo $ff | perl -ne '$_ =~ /(AS.*)\.wav$/; print $1'  >> text
  setenv SENT_ID `echo $ff | perl -ne '$_ =~ /.*\d\d(\d\d)\.wav$/; print $1'`
  grep $SENT_ID $inFile | perl -ne '$_ =~ /\d+\s+(.+)$/; print "\t$1\n"' >> text
end

# REVISION HISTORY	: 
