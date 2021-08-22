#!/bin/bash 
clear
date
#set-up for single machine or cluster based execution
. ./cmd.sh
#set the paths to binaries and other executables
[ -f path.sh ] && . ./path.sh

#rm -rf data
#cp -r exp_phone_level_trans_tts/data data/

train_cmd=run.pl
decode_cmd=run.pl
test_dir1=data/test
test_lang_dir1=data/lang_bigram
graph_dir1=graph_test_bigram
decode_dir1=decode_test_bigram

rm -rf $test_dir1/*
test_create_wav_scp.sh

  echo "         MFCC Feature Extration & CMVN         "
  mfccdir=mfcc
  for x in test ; do 
	steps/make_mfcc.sh --cmd "$train_cmd" --nj 1 data/$x exp/make_mfcc/$x $mfccdir || exit 1;
 	steps/compute_cmvn_stats.sh data/$x exp/make_mfcc/$x $mfccdir || exit 1;
	utils/fix_data_dir.sh data/$x
	utils/validate_data_dir.sh data/$x
  done

decode_nj=1	# test file(s) from single speaker
  echo "                   MonoPhone Testing"
  utils/mkgraph.sh --mono $test_lang_dir1 exp/mono exp/mono/$graph_dir1 || exit 1;
  steps/decode.sh --nj "$decode_nj" --cmd "$decode_cmd" exp/mono/$graph_dir1 $test_dir1 exp/mono/$decode_dir1 || exit 

if (-e phoneTranscription.txt) rm phoneTranscription.txt
egrep '^demo' exp/mono/$decode_dir1/log/decode.1.log | cut -c 7- > phoneTranscription.txt

date
exit


