#!/bin/csh
# This script generates the wavefiles of a given speaker
# to a new directory.
# spkrReco: 0nawajij	8 new speakers	Bengali ASR database
# implicit INPUT	: *.flac files in folders
#			utt_spk_text.tsv
# implicit OUTPUTs	: wavefiles of a speaker in one folder

cd ~/Desktop/
foreach spkr (16cfb 976b1 f83df 9813c 7ec1c e43d4 5639c 321b6)
  if (-d wav_$spkr) rm -rf wav_$spkr
  mkdir wav_$spkr

  foreach ff (` grep $spkr utt_spk_text.tsv | perl -nae 'print $F[0],"\n"' `)
    set let1 = `echo $ff | cut -c 1`
    set let2 = `echo $ff | cut -c 1-2`
    set fname_in  = "asr_bengali_"$let1"/data/"$let2"/$ff.flac"
    set fname_out = wav_$spkr/$ff.wav
    ffmpeg -v 0 -i $fname_in $fname_out 
  end

end
exit


