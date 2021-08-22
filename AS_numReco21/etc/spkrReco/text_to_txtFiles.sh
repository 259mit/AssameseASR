#!/bin/csh
# This script generates *.txt files corresponding to *.wav files
# implicit INPUT	: etc/text
# implicit OUTPUTs	: txt/*.txt


cdkaldi
if (! -d txt) mkdir txt

foreach line ("`cat etc/text`")
  set fname = `echo $line | perl -nae 'print $F[0]' `

  echo $line | perl -ne '$~ = /^\S+\s+(.+)$/; print "$1 \n"' > txt/$fname.txt
  #the following worked for Hirok
  #echo $line | perl -ne '$~ = /^\S+\s+(.+)$/; print "$1' > txt/$fname.txt
#  echo $line | perl -nae 'foreach $w (@F[1..$#F]) {print "$w "}; print "\n"' > txt/$fname.txt
#  echo $line | perl -ne 'chomp; @F = split(/\t/, $_); foreach $w (@F[1..$#F]) {print "$w "}; print "\n"' > txt/$fname.txt
#  echo $line | perl -ne 'chomp; $~ = /^\s*\S+\s+(\S+.+\S+)\s*$/; print "$1\n"' > txt/$fname.txt
end

exit
