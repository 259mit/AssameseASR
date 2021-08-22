#!/usr/bin/perl -w
#**********************************************************************
# PURPOSE     : if a word in transcription does not have an entry
#                 in dictionary, print the word
# INPUT       : etc/lexicon.txt and etc/utt_spk_trans_train.txt
# OUTPUT      : list of words not present in lexicon.txt
# AUTHOR      : chief
# DATE WRITTEN: Mar 2021; May 2020
# Pseudocode
#**********************************************************************
if($#ARGV < 1) {
    die "USAGE   : $0 in_lexicon.txt in_utt_spk_trans_train.txt\n".
        "Example : $0 etc/lexicon.txt etc/utt_spk_trans_train.txt\n"
        }

($lexicon, $in_text) = @ARGV;
open(IN,"<$lexicon")   || die "Can't open $lexicon :$!";
while ($line = <IN>) {
  chomp($line);
  ($word, $labelSeq) = split (/\t/,$line);
  $word2labelSeq{$word} = $labelSeq; 
} # End of while ($line = <IN>) {
close IN;

open(IN,"<$in_text")   || die "Can't open $in_text :$!";
print "The following words occur in $in_text\n".
	"but does not occur in $lexicon\n";
print "word\tsentence-------\n";
while ($line = <IN>) {
  chomp($line);		# AS011M0003      011M    ek nax xaat paas tini ek dui
  @F = split (/\s+/, $line);
#  foreach $w (@F[1..$#F]) {
  foreach $w (@F[2..$#F]) {
    $labelSeq = $word2labelSeq{$w};
    if (! $labelSeq) {
      print "$w\t$line\n";
    }
  }
} # End of while ($line = <IN>) {
close IN;
