#!/bin/csh
# This script generates files needed by Kaldi for training
# implicit INPUTs:
#	etc/lexicon.txt
#	etc/utt_spk_trans_train.txt
#	etc/utt_spk_trans_test.txt
# 		Each line of the file etc/utt_spk_trans*.txt contains 3 columns:
#		  AS011M0003	011M	ek nax xaat paas tini ek dui
# AUTHOR	: Samudravijaya K (samudravijaya@gmail.com)
# DATE WRITTEN	: 20-AUG-2021 <- 27-MAR-2021


# 1) Clean old directories/files, if present
#cdkaldi
rm -rf mfcc exp data
mkdir -p exp data/train data/test
mkdir -p data/lang_bigram data/local/dict
# Clean directories first
#touch data/local/dict/lexicon.txt data/train/text data/test/text data/test/utt_spk_trans_test.txt data/train/utt_spk_trans_train.txt
#rm    data/local/dict/lexicon.txt data/train/text data/test/text data/test/utt_spk_trans_test.txt data/train/utt_spk_trans_train.txt

sort etc/lexicon.txt  > data/local/dict/lexicon.txt
cp etc/utt_spk_trans_train.txt data/train
cp etc/utt_spk_trans_test.txt data/test

# Process files in data/train directory
cd data/train

cat utt_spk_trans_train.txt | perl -ne '@F=split(/\t/, $_); printf "%s\t%s", $F[0], $F[2];'| sort -u >! text
# The above command creates the "text" file containing uttId and transcription.
# An example line is	AS0001M0010	xunnyo xunnyo nax aath xaat soi paas

perl -nae 'print "$F[0]\n"' text  >! utt
#The above command creates a file called "utt" that contains the first column of "text" file. The first two lines of the file will appear as
#  AS0001M0010
#  AS0001M0011

perl -nae 'print "$F[1]\n"' utt_spk_trans_train.txt  >! spk
#The above command creates a file called "spk" that contains the 2nd column of "utt_spk_trans_train.txt" file which is spk_id.

# Now one needs to create a file called "utt2spk" that contains 
# lines containing the name of the wave file and the id of the speaker
paste utt spk | sort | sort -k 2 >! utt2spk
../../utils/utt2spk_to_spk2utt.pl utt2spk >! spk2utt
perl -nae 'print "@F[1..$#F]\n";'  text  >!  trans
perl -nae 'print "<s> @F[1..$#F] </s>\n";'  text  >!  lm_train.txt


# Repeat the process for test data  -------------
cd ../test
cat utt_spk_trans_test.txt | perl -ne '@F=split(/\t/, $_); printf "%s\t%s", $F[0], $F[2];'| sort -u >! text
perl -nae 'print "$F[0]\n"' text  >! utt
perl -nae 'print "$F[1]\n"' utt_spk_trans_test.txt  >! spk
paste utt spk | sort | sort -k 2 >! utt2spk
../../utils/utt2spk_to_spk2utt.pl utt2spk >! spk2utt
perl -nae 'print "@F[1..$#F]\n";'  text  >!  trans
perl -nae 'print "<s> @F[1..$#F] </s>\n";'  text  >!  lm_train.txt


# Process text/grammar files
  cd ../../data/local/dict
  touch extra_phones.txt extra_questions.txt

#The "lexicon.txt" file should necessarily contain the following two lines:
#  sil	sil
#  !SIL	sil
#The "lexicon.txt" file should NOT contain <s> or </s>
#The "lexicon.txt" file should NOT have duplicate lines
#The "lexicon.txt" file should NOT contain empty lines.
#The following command ensures the above 4 constraints on lexicon.txt
  mv lexicon.txt orig.lexicon.txt
  perl -e  'printf  "sil\tsil\n"'   >> orig.lexicon.txt
  perl -e  'printf  "\!SIL\tsil\n"'   >> orig.lexicon.txt
  grep -v '<s>' orig.lexicon.txt | grep -v '</s>' | grep '\w' | sed -e 's/\r//' | sort -u >! lexicon.txt
  perl -nae 'foreach $p(@F[1..$#F]){print "$p\n"}' lexicon.txt |sort -u >! phones.txt
  grep -v sil phones.txt >! nonsilence_phones.txt

#The last 2 commands create (i) "phones.txt" that contains a unique list of all phone_level labels in the "lexicon.txt", and (ii)  "nonsilence_phones.txt" that contains the list of all unique phones excluding sil.
#Inspect the file "phones.txt" to ensure that it contains valid symbols.
#If not, edit lexicon.txt and execute the set of 6 commands to regenerate phones.txt
 
#If you have used additional 'silent' phone labels such as  <cough> <hmm>, append all such phone labels to "lexicon.txt" now (after creating the "non_silence_phones.txt") as follows:
#  <cough>	cough
#  <hmm>	hmm

#The following commands create two files needed by kaldi. 
  echo "sil" >! silence_phones.txt
  echo "sil" >! optional_silence.txt

echo "If there are errors, resolve the errors."

exit
