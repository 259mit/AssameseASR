#!/usr/bin/python3
#
# Written by Dibyajyoti Choudhury.
#
# This program converts Assamese words into their corresponding
# transliteration and sequence of ILSL labels(pronounciation).
#
# USAGE : ./as_word2dict.py input.txt output.txt
#
# input.txt contains list of unique Assamese words(one word per line)
#
# output.txt contains 3 columns.
#	1st column: Assamese word
#	2nd column: transliteration
#	3rd column: pronounciation


import sys

if len(sys.argv) < 3 :
	print("The program needs two filenames")
	print("Usage : ./as_word2dict.py input.txt output.txt")
	print("Example : ./as_word2dict.py as_wordList.txt as_dict.txt")
	sys.exit(1)


# Function to map from Assamese character to their corresponding ILSL label
# if character is not found in the following dictionary, then "" (empty string) will be returned.

def asUni_to_Ilsl(char) :

	asUni_to_Ilsl_dict = {

		#Vowels

		0x0985 : "ax",
		0x0986 : "aa",
		0x0987 : "i",
		0x0988 : "i",
		0x0989 : "u",
		0x098a : "u",
		0x098b : "rq",
		0x098f : "e",
		0x0990 : "oi",
		0x0993 : "o",
		0x0994 : "ou",

		#Consonants

		0x0995 : "k",
		0x0996 : "kh",
		0x0997 : "g",
		0x0998 : "gh",
		0x0999 : "ng",
		0x099a : "s",
		0x099b : "s",
		0x099c : "j",
		0x099d : "jh",
		0x099e : "nj",
		0x099f : "t",
		0x09a0 : "th",
		0x09a1 : "d",
		0x09a2 : "dh",
		0x09a3 : "n",
		0x09a4 : "t",
		0x09a5 : "th",
		0x09a6 : "d",
		0x09a7 : "dh",
		0x09a8 : "n",
		0x09aa : "p",
		0x09ab : "ph",
		0x09ac : "b",
		0x09ad : "bh",
		0x09ae : "m",
		0x09af : "j",
		0x09f0 : "r",
		0x09b2 : "l",
		0x09f1 : "w",
		0x09b6 : "x",
		0x09b7 : "x",
		0x09b8 : "x",
		0x09b9 : "h",
		0x09dc : "r",
		0x09dd : "dxhq",
		0x09df : "y",

		0x09ce : "t",   # Khanta ta
		0x0982 : "ng",  # Anuswar
		0x0983 : "hq",   # Bixarga
		0x0981 : "n",   # Chandrabindu
		
		#Matra

		0x09be : "aa",
		0x09bf : "i",
		0x09c0 : "i",
		0x09c1 : "u",
		0x09c2 : "u",
		0x09c3 : "rq",
		0x09c7 : "e",
		0x09c8 : "oi",
		0x09cb : "o",
		0x09cc : "ou",

		#Extra

		0x2018 : "o",
		0x2019 : "o",
		0x0027 : "o"

	}

	if char in asUni_to_Ilsl_dict :
		return asUni_to_Ilsl_dict[char]

	elif char == 0x09bc :
		return "?"
	else:
		return ""



# Function to check whether a character is a consonant or not

def isConsonant(ch) :
	return True if 0x0995 <= ch <= 0x09b9 or 0x09dc <= ch <= 0x09df or 0x09f0 <= ch <= 0x09f1 else False



# Function to check whether a character is a matra or not

def isMatra(ch) :
	return True if 0x09be <= ch <= 0x09cc else False



# Function to replace phone labels by appropriate one (e.g. 'a a' by 'aa')

def replacePhone(phSeq) :

	new_phSeq = phSeq

	phone_label_replace_dict = { \

		"a x" : "ax",
		"a a" : "aa",
		"i i" : "ii",
		"u u" : "uu",
		"r q" : "rq",
		"o i" : "oi",
		"o u" : "ou",

		"k k" : "kk",
		"k h" : "kh",
		"g g" : "gg",
		"g h" : "gh",
		"n g" : "ng",
		"s s" : "ss",
		"j j" : "jj",
		"j h" : "jh",
		"n j" : "nj",
		"t t" : "tt",
		"t h" : "th",
		"d d" : "dd",
		"d h" : "dh",
		"n n" : "nn",
		"p p" : "pp",
		"p h" : "ph",
		"b b" : "bb",
		"b h" : "bh",
		"m m" : "mm",
		"l l" : "ll",
		"h q" : "hq"
	
	}

	for key in phone_label_replace_dict :
		new_phSeq = new_phSeq.replace( key, phone_label_replace_dict[key] )

	return new_phSeq



# Open input and output files.

try:
	infile = open(sys.argv[1], "r")		# Open the input file in read mode

except:
	print("File '", sys.argv[1] ,"' not found!")


outfile = open(sys.argv[2], "w+")	# Open the output file in write mode
	

for word in infile:			# For each line in the file
					# each line contains one word

	word = word.rstrip("\n")

	outfile.write(word + "\t")	# Write the Assamese word

	prevChar = ''
	currChar = ''
	travFirstCh = False
	transWord = ""

	for ch in word:			#For each character in the current word

		currChar = ord(ch)
		
		il = asUni_to_Ilsl(currChar)

		# Check whether "ax" can be given after previous char
		# if first char is traversed and
		# previous char is NOT 'anuswar' and
		# current char is neither a hasanta nor matra
		# previous char is a consonant
		
		if travFirstCh and not isMatra(currChar) and currChar != 0x09cd and ch != "'" and ch != "_" and isConsonant(prevChar) :
			
			transWord += "ax"

		travFirstCh = True


		# Check whether 'j' and NUKTA are occuring together in sequence
		# if previous char is 'j' and
		# current char is NUKTA and
		# length of the transliterated word is greater than 1
 
		if prevChar == 0x09af and currChar == 0x09bc and len(transWord) > 1:
			transWord = transWord[:-1] + "y"

			prevChar = 0x09df	#putting prev char as 'y'
			il = ""

		# Check for conjunction of "s" with it's following letter
		# if current letter = hasanta and
		# previously traversed letter = "x"

		elif currChar == 0x09cd and asUni_to_Ilsl(prevChar) == "x" :
			
			transWord = transWord[:-1] + "s"
			prevChar = currChar
			il = ""

		# Check for conjunction of "s" or "t" with "b"
		# if current letter = "b" and
		# previously traversed letter = hasanta and
		# last letter of the transliterated word = "s" or "t"

		elif il == "b" and prevChar == 0x09cd and transWord[-1] in ["s", "t", "j"] :

			il = transWord[-1]
			prevChar = currChar

		# Check for Assamese letter 'kkha'
		# if current letter = "x" and
		# previously traversed letter = hasanta and
		# last letter of the transliterated word = "k"

		elif il == "x" and prevChar == 0x09cd and transWord[-1] == "k" :
			
			il = "kh"
			prevChar = 0x0996

		# Check for 'jya kaar'
		# if current letter = "j" and
		# previously traversed letter = hasanta
	
		elif currChar == 0x09af and prevChar == 0x09cd :
		
			il = "y"
			prevChar = 0x09df

		# Check for 'gya' eg. 'pragyan'

		elif prevChar == 0x09cd and il == "nj" and transWord[-1] == "j" :

			transWord = transWord[:-1]
			il = "gy"
			prevChar = currChar

		else :
			prevChar = currChar

		transWord += il


	# Check whether the last char of the current word is consonant and not anuswar

	#if isConsonant(prevChar) and prevChar != 0x0982 :
		#transWord += "ax"
	
	#outfile.write(transWord + "\t")

	ilsl_seq = ' '.join(list(transWord))

	ilsl_seq = replacePhone(ilsl_seq)

	outfile.write(ilsl_seq + "\n")


infile.close();
outfile.close();





