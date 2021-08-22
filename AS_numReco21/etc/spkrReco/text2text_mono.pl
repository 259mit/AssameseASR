#!/usr/bin/perl -w
#**********************************************************************
# PURPOSE     : convert word sequence to phone sequence
# INPUT       : kaldi "text" file.
#		: kaldi "lexicon.txt" file
# OUTPUT      : equivalent kaldi "text_monophone" file
# AUTHOR      : chief
# DATE WRITTEN: May 2020
# Pseudocode
#**********************************************************************
if($#ARGV < 2) {
    die "USAGE   : $0 in_kaldi_lexicon.txt in_kaldi_text out_text_monophone\n".
        "Example : $0 lexicon.txt text text_monophone\n"
        }

($lexicon, $in_text, $out_text) = @ARGV;
open(IN,"<$lexicon")   || die "Can't open $lexicon :$!";
while ($line = <IN>) {
  chomp($line);
  ($word, $labelSeq) = split (/\t/,$line);
  $word2labelSeq{$word} = $labelSeq; 
} # End of while ($line = <IN>) {
close IN;

open(OUT,">$out_text") || die "Can't open output file $out_text :$!";
open(IN,"<$in_text")   || die "Can't open $in_text :$!";
while ($line = <IN>) {
  chomp($line);
  @F = split (/\s+/, $line);
  print OUT "$F[0]\t";

  foreach $w (@F[1..$#F]) {
    $labelSeq = $word2labelSeq{$w};
    if ($labelSeq) {
      $labelSeq =~ s/\s+$//; 
      print OUT $labelSeq, " ";
    } else { 
      print "$w does not occur in $lexicon\n";
    }
  }
  print OUT "\n";
} # End of while ($line = <IN>) {
close IN;
close OUT;
