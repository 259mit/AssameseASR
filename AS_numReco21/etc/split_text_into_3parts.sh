#!/bin/csh
# This script divides the text into 3 parts:  text1, text2 and text3

cd etc
echo "speakerId   numberOfFiles"
foreach spkrId ( `perl -nae 'print $F[0],"\n"' ../data/train/spk2utt` )
  echo -n "$spkrId "
  grep -e "^$spkrId" text |wc
end
touch text1; rm text?
touch text1 text2 text3
set n=1
foreach spkrId ( `perl -nae 'print $F[0],"\n"' ../data/train/spk2utt` )
  grep -e "^$spkrId" text >> text$n
  @ n++
  if ($n == 4) set n = 1
end
wc text text?

