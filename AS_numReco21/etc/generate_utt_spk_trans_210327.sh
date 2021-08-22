#!/bin/csh
# NAME OF THE FILE 	: .../kaldi-master/egs/0chief/AS_numReco/etc/
#				generate_utt_spk_trans_210327.sh
# PURPOSE		: To generate files containing fileId, spkId and #			  transcriptions corresponding to wav/*.wav files. Ex:
#			  AS011M0001	011M	xunnyo xunnyo nax aath xaat soi paas
# INPUT ARGUMENTS	: Text file containing sentences preceded by serial numbers
# IMPLICIT OUTPUT	: etc/utt_spk_trans_train.txt and
#			  etc/utt_spk_trans_test.txt              
# AUTHOR		: Samudravijaya K (samudravijaya@gmail.com)
# DATE WRITTEN		: 20-AUG-2021 <- 27-MAR-2021 <- 25-MAY-2018 
#----------------------------------------------------------------------------
if ($#argv < 1) then
 echo "Usage  : $0 inSentenceList"
 echo "Example: $0 etc/numbers80_AS.txt"
 exit 1
endif

#cdkaldi			# === cd .../kaldi-master/egs/0chief/AS_numReco
set inFile = $1
touch temp
foreach ff (`ls wav/*.wav`)
  echo $ff | perl -ne '$_ =~ /(AS.*)\.wav$/; print $1'  >> temp
  echo $ff | perl -ne '$_ =~ /AS(\d\d\d\w)/; print "\t$1"'  >> temp
  setenv SENT_ID `echo $ff | perl -ne '$_ =~ /.*\d\d(\d\d)\.wav$/; print $1'`
  grep $SENT_ID $inFile | perl -ne '$_ =~ /\d+\s+(.+)$/; print "\t$1\n"' >> temp
end

if (-e etc/utt_spk_trans_train.txt) rm etc/utt_spk_trans_train.txt
mv temp etc/utt_spk_trans_train.txt
# Test data is same as train data.
if (-e etc/utt_spk_trans_test.txt) rm etc/utt_spk_trans_test.txt
cp etc/utt_spk_trans_train.txt etc/utt_spk_trans_test.txt

