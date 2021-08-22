#!/bin/csh
# create wav.scp corresponding to wavefiles in wav/ directory.
set wav_path = $PWD/wav
set data_path = $PWD/data/test
ls $wav_path/*.wav > wavList.txt
if (-e $data_path/utt) rm $data_path/utt
touch $data_path/utt
foreach ff ( `cat wavList.txt` )
  basename $ff .wav >> $data_path/utt
end
if (-e $data_path/wav.scp) rm $data_path/wav.scp
paste $data_path/utt wavList.txt > $data_path/wav.scp
rm wavList.txt

paste $data_path/utt $data_path/utt > $data_path/utt2spk
utils/utt2spk_to_spk2utt.pl $data_path/utt2spk > $data_path/spk2utt

exit


#--------------------

sort etc/text_monophone | \
	perl -nae 'print "<s> @F[1..$#F] </s>\n";' > \
	data/train/lm_train.txt

head data/train/lm_train.txt
exit
