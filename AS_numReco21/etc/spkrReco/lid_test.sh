#!/bin/bash
# lid.sh   will use one core
clear
date

rm lid_output.txt
cd BN_IN1

for n in 1 2 3 4 5 6 7 8 9
do

cd ../BN_IN"$n"
baseDir=$PWD
pwd

#set-up for single machine or cluster based execution
. ./cmd.sh
#set the paths to binaries and other executables
[ -f path.sh ] && . ./path.sh
train_cmd=run.pl
decode_cmd=run.pl

ngauss=16
decode_nj=1

train_dir1=data/train
train_lang_dir=data/lang_bigram
###nohup lid_test.sh >& log_lid.txt  &
test_dir1=data/test
test_lang_dir1=data/lang_bigram

graph_dir1=graph_test_bigram
decode_dir1=decode_test_bigram

# preparation of files in data/test directory: text,utt2spk etc. 
touch data/test/text data/test/cmvn.scp
rm    data/test/text data/test/cmvn.scp
sort $baseDir/etc/text_test  > data/test/text
cd data/test
  perl -nae 'print "$F[0]\n"' text  > utt 
  cat utt | cut -b 1-8 > spk
  paste utt spk > utt2spk
  ../../utils/utt2spk_to_spk2utt.pl utt2spk > spk2utt
  perl -nae 'print "@F[1..$#F]\n";'  text  >  trans
  perl -nae 'print "<s> @F[1..$#F] </s>\n";'  text  >  lm_test.txt
cd ../../

# preparation of wav.scp
wav_path=$baseDir/wav
data_path=$PWD/data/test
cat $data_path/utt | awk '{printf "%s\t%s%s%s\n",$1,"'$wav_path'/",$1,".wav"}' > $data_path/wav.scp

#extract MFCC features and perform CMVN
  mfccdir=mfcc
  for x in test ; do 
	steps/make_mfcc.sh --cmd "$train_cmd" --nj 3 data/$x exp/make_mfcc/$x $mfccdir || exit 1;
 	steps/compute_cmvn_stats.sh data/$x exp/make_mfcc/$x $mfccdir || exit 1;
	utils/fix_data_dir.sh data/$x
	utils/validate_data_dir.sh data/$x
  done


# Recognise the test utterances
  utils/mkgraph.sh --mono $test_lang_dir1 exp/mono exp/mono/$graph_dir1 || exit 1;
  steps/decode.sh --nj "$decode_nj" --cmd "$decode_cmd" exp/mono/$graph_dir1 $test_dir1 exp/mono/$decode_dir1 || exit 

# print the fileId and log-likelihood pairs
touch ../lid_output.txt
export MODEL_ID=`pwd | perl -ne '$_ =~ /\/(\w+)$/; printf "$1\t"' `
perl -ne 'if ($_ =~ /Log-like per frame for utterance (\S+) is (-\d\.\d+) over \d+ frames./) {printf "%s\t%s\t%s\n", $ENV{'MODEL_ID'}, $1, $2}' exp/mono/decode_test_bigram/log/decode.1.log >> ../lid_output.txt

done

