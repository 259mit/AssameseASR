#!/bin/csh
# This script generates files needed by Kaldi
# implicit INPUTs	: etc/lexicon.txt
#			  etc/orig_train.txt
#			  etc/orig_test.txt
cd ~/kaldi-trunk/egs/0urbi/Nepali_ASR
# Clean directories first
touch data/local/dict/lexicon.txt data/train/text data/test/text data/test/orig_test.txt data/train/orig_train.txt
rm    data/local/dict/lexicon.txt data/train/text data/test/text data/test/orig_test.txt data/train/orig_train.txt

# Sort the "lexicon.txt" file 
  sort etc/lexicon.txt  >! data/local/dict/lexicon.txt
# Create "text" (corresponding to train data) in data/train
# Repeat for test data as well (if the corresponding "text" exists)
#	sort etc/text_AS_part1.txt > data/test/text
#	cat etc/text_AS_part2.txt etc/text_AS_part3.txt | sort > data/train/text

#copying orig_train.txt to train to extract spk id in line no 50 & and file_name and utt to make a file called text
cp etc/orig_train.txt data/train   
cd data/train

# pulling F[1]&F[2] in text file
cat orig_train.txt | perl -ne '@F=split(/\t/, $_); printf "%s\t%s", $F[0], $F[2];'| sort -u >! text

perl -nae 'print "$F[0]\n"' text  >! utt
#The last command creates a file called "utt" that contains the first column of "text" file. The first few lines of the file will appear as
#  AS0001M0010
#  AS0001M0011

perl -nae 'print "$F[1]\n"' orig_train.txt  >! spk
#The last command creates a file called "spk" that contains the 2nd column of "orig_train.txt" file which is spk_id.

# Now one needs to create a file called "utt2spk" that contains 
# lines containing the name of train wave file and the id of the speaker

paste utt spk | sort | sort -k 2 >! utt2spk

../../utils/utt2spk_to_spk2utt.pl utt2spk >! spk2utt
perl -nae 'print "@F[1..$#F]\n";'  text  >!  trans
perl -nae 'print "<s> @F[1..$#F] </s>\n";'  text  >!  lm_train.txt

#copying the text file in etc folder as text_train
cp text ../../etc/text_train

#Repeat the process for test data
cd ../../
cp etc/orig_test.txt data/test 
cd data/test

# pulling F[1]&F[2] in text file
cat orig_test.txt | perl -ne '@F=split(/\t/, $_); printf "%s\t%s", $F[0], $F[2];'| sort -u >! text

perl -nae 'print "$F[0]\n"' text  >! utt
#The last command creates a file called "utt" that contains the first column of "text" file. The first few lines of the file will appear as
#  AS0001M0010
#  AS0001M0011

perl -nae 'print "$F[1]\n"' orig_test.txt  >! spk
#The last command creates a file called "spk" that contains the 2nd column of "orig_test.txt" file which is spk_id.

# Now one needs to create a file called "utt2spk" that contains 
# lines containing the name of train wave file and the id of the speaker

paste utt spk | sort | sort -k 2 >! utt2spk
#paste utt spk >! utt2spk
../../utils/utt2spk_to_spk2utt.pl utt2spk >! spk2utt
perl -nae 'print "@F[1..$#F]\n";'  text  >!  trans
perl -nae 'print "<s> @F[1..$#F] </s>\n";'  text  >!  lm_train.txt

#copying the text file in etc folder as text_train
cp text ../../etc/text_test


#.............................
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
    perl   -e  'printf  "sil\tsil\n"'   >> orig.lexicon.txt
  perl   -e  'printf  "\!SIL\tsil\n"'   >> orig.lexicon.txt
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
