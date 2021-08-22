#!/bin/csh
# Commands to generate a list of unique phone-like symbols from a dictionary.
#Input: a dictionary file having 2(two) columns as shown below:
#wordInNativeScript	list of phoneSymbols	

#Output: a list of unique phone-like symbols

if ($#argv < 1) then
	echo "Usage  : $0 <dictionaryFileName>";
	echo "Example: $0 bengali_dict.tsv";
	exit 1;
endif
set dict = $argv[1];

perl -ne ' @F = split (/\t/, $_); foreach $ph (@phoneList = split (/\s+/, $F[1]) ){print $ph,"\n";}' $dict | sort -u > ! phoneList_${dict}.txt

