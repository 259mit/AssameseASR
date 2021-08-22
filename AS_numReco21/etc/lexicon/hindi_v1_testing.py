#!/usr/bin/python3
#
# Author: Dibyajyoti Choudhury	May 2020
#	Adapted for Devanagari script by SamudraVijaya
#
# This program generates an initial version of a pronunciation dictionary
# from an input file containing a list Hindi words (in utf8 format).
# The phone labels follow the ILSL convention.
# More on ILSL is at https://www.iitg.ac.in/samudravijaya/tutorials/index_tutorials_resources.html
# 
#
# USAGE : ./hindi_word2dict.py input.txt output.txt
#
# input.txt contains list of unique Hindi words(one word per line)
#
# output.txt contains 2 columns separated by a tab
#	1st column: Hindi word
#	2nd column: space separated sequence of ILSL labels of 
#			phone-like units corresponding to the
#			pronounciation of that word

import sys,pdb

#pdb.set_trace()
if len(sys.argv) < 3 :
	print("The program needs two filenames")
	print("Usage   : ./hindi_word2dict.py input.txt output.txt")
	print("Example : ./hindi_word2dict.py hindi_wordList.txt hindi_dict.txt")
	sys.exit(1)


# Function to map from Hindi (Devanagari) character to their corresponding ILSL label
# if character is not found in the following dictionary, then "" (empty string) will be returned.

def hindiUni_to_Ilsl(char,need_char) :
	lst=[]
	hindiUni_to_Ilsl_dict = {

		#Vowels

		0x0905 : "a",
		0x0906 : "aa",
		0x0907 : "i",
		0x0908 : "ii",
		0x0909 : "u",
		0x090a : "uu",
		0x090b : "rq",
		0x090d : "ae",
		0x090f : "ee",
		0x0910 : "ei",
		0x0911 : "ax",
		0x0913 : "o",
		0x0914 : "ou",

		#Consonants

		0x0915 : "k",
		0x0916 : "kh",
		0x0917 : "g",
		0x0918 : "gh",
		0x0919 : "ng",
		0x091a : "c",
		0x091b : "ch",
		0x091c : "j",
		0x091d : "jh",
		0x091e : "nj",
		0x091f : "tx",
		0x0920 : "txh",
		0x0921 : "dx",
		0x0922 : "dxh",
		0x0923 : "nx",
		0x0924 : "t",
		0x0925 : "th",
		0x0926 : "d",
		0x0927 : "dh",
		0x0928 : "n",
		0x092a : "p",
		0x092b : "ph",
		0x092c : "b",
		0x092d : "bh",
		0x092e : "m",
		0x092f : "y",
		0x0930 : "r",
		0x0932 : "l",
		0x0933 : "lx", 			0x0935 : "w",
		0x0936 : "sh",
		0x0937 : "sx",
		0x0938 : "s",
		0x0939 : "h",
		0x09dc : "r",
		0x09dd : "dxhq",
		0x092f : "y",

		#Matra

		0x093e : "aa",
		0x093f : "i",
		0x0940 : "ii",
		0x0941 : "u",
		0x0942 : "uu",
		0x0943 : "rq",
		0x0945 : "ae",
		0x0947 : "ee",
		0x0948 : "ei",
		0x094b : "o",
		0x094c : "ou",

		# nukta [dot below] (fricatives / flap / tap)

		0x0958 : "kq",
		0x0959 : "khq",
		0x095a : "gq",
		0x095b : "z",
		0x095c : "dxq",
		0x095d : "dxhq",
		0x095e : "f",

		#Extra

		0x0903 : "h",   # Visarga
		0x0972 : "ae",	# ae of  bank, air
		0x0974 : "aan",	# nasalized long aa
		0x093b : "aan",	# nasalized long aa

		#suffixes: special situations
		0x0902 : "nq",  # Anuswara (a nasal whose place of articulation is that of the following consonant)
		0x0901 : "M",	# Chandrabindu (preceding vowel is nasalized)
		0x093a : "M",	# Chandrabindu (preceding vowel is nasalized)
		0x093c : "q"	# nukta: previous consonant is a fricative

	}
	if(need_char):
		if char in hindiUni_to_Ilsl_dict :
			return hindiUni_to_Ilsl_dict[char]
		else:
			return ""
	elif (need_char ==0):

		for key, value in hindiUni_to_Ilsl_dict.items(): 
			if char == value :
				return(key) 

	




# Function to check whether a character is a consonant or not

def isConsonant(ch) :
	return True if 0x0915 <= ch <= 0x0939 or 0x0958 <= ch <= 0x095f or 0x09f0 <= ch <= 0x09f1 else False
##	return True if 0x0915 <= ch <= 0x0939 or 0x09dc <= ch <= 0x09df or 0x09f0 <= ch <= 0x09f1 else False



# Function to check whether a character is a matra or not

def isMatra(ch) :
	return True if 0x093e <= ch <= 0x094c else False



# Function to replace phone labels by appropriate one (e.g. 'a a' by 'aa')

def replacePhone(phSeq) :

	new_phSeq = phSeq

	phone_label_replace_dict = { \

		"a x" : "ax",
		"a a" : "aa",
		"i i" : "ii",
		"u u" : "uu",
		"e e" : "ee",
		##"r q" : "rq",
		"e i" : "ei",
		"o u" : "ou",

		# retroflex sounds
		" x"  : "x",
		# gemination and aspiration
		"k k" : "kk",		# velar
		"k h" : "kh",	##?
		"g g" : "gg",
		"g h" : "gh",
		"n g" : "ng",	##?
		"c c" : "cc",		# affricate (palatal)
		"c h" : "ch",	##?
		"j j" : "jj",
		"j h" : "jh",	##?
		"n j" : "nj",	##?
		"tx tx" : "ttx",	# retroflex
		"tx h" : "txh",	##?
		"dx dx" : "ddx",
		"dx h" : "dxh",	##?
		"nx nx" : "nnx",
		"t t" : "tt",		# dental
		"t h" : "th",	##?
		"d d" : "dd",
		"d h" : "dh",	##?
		"n n" : "nn",
		"p p" : "pp",		# bilabial
		"p h" : "ph",	##?
		"b b" : "bb",
		"b h" : "bh",	##?
		"m m" : "mm",

		"y y" : "yy",		# other geminated consonants
		"r r" : "rr",
		"l l" : "ll",
		"lx lx" : "llx",
		"w w" : "ww",
		"s s" : "ss",
		"s x" : "sx",
		"sh sh" : "ssh",
		"s h" : "sh",
		"sx sx" : "ssx",
		"h h" : "hh",

		#suffixes: special situations
		#"mq"	: "n",	# chandrabindu: previous vowel is nasalized
		#"m q" : "n",	# Chandrabindu (preceding vowel is nasalized)
		" M" : "n",	# Chandrabindu (preceding vowel is nasalized)
		#0x0902 : "nq",  # Anuswara (a nasal whose place of articulation is that of the following consonant)
		"nq k"	: "ng k",
		"nq c"	: "nj c",
		"nq tx"	: "nx tx",
		"nq t"	: "n t",
		"nq p"	: "m p",

		"nq gh"	: "ng gh",
		"nq jh"	: "nj jh",
		"nq dxh" : "nx dxh",
		"nq dh"	: "n dh",
		"nq bh"	: "m bh",
		# after anuswara(bindu), voiced unaspirated plosives rarely manifest 
		"nq g"	: " ng ",
		"nq j"	: " nj ",
		"nq dx"	: " nx ",
		"nq d"	: " n ",
		"nq b"	: " m ",
	
		" a q"	: "",	# delete "a" when followed by nukta (chodx)
		"q"	: "",	# remove any remaining q
		"  "	: " "
	}

	for key in phone_label_replace_dict :
		new_phSeq = new_phSeq.replace( key, phone_label_replace_dict[key] )

	return new_phSeq
###############################################################################################################
# Rule 1: "akabar"
# the a between k and b is deleted because it is not the first vowel AND it is not the last vowel of the word.
###############################################################################################################
def rule1(Inputstr):
	a_count=0
	a1_position=[]
	del_position=[]
	#Inputstr =list(Inputstr)
	for a_position, char in enumerate(Inputstr):
		if char=='a' :
			a_count+=1
			a1_position += [a_position]
	if (a_count ==0):
		return (Inputstr)
	else:		
		first_a_position = a1_position[0]
		length_array= len(a1_position)
		last_a_position = a1_position[length_array -1]
		if(a_count > 2):
			for pos in range(len(a1_position)):
				if (first_a_position < a1_position[pos] < last_a_position):
					del_position += [a1_position[pos]]
		for i in range(len(del_position)):
			new_str = Inputstr[:(del_position[i])] + Inputstr[(del_position[i]+1):]
			return (new_str)
	return(Inputstr)
###################################################################################################################
#Rule 0:if the first AND second vowel of a word is "a", AND the second consonant is "h", replace both first and
# second vowels by "ea"
##कहना	k a h a n aa
#-->
#कहना	k ea h ea n aa
###################################################################################################################
def rule_0_schwa_del(string_input):
	vowel_list=['a','aa','i','ii','u','uu','rq','ae','ee','ei','ax','o','ou']
	consonant_list=['k','kh','g','gh','ng','c','ch','j','jh','nj','tx','txh','dx','dxh','nx'
			,'t','th','d','dh','n','p','ph','b','bh','m','y','r','l','lx','w','sh','sx','s','h','dxhq','y']
	
	Vinstr=[]
	Cinstr =[]
	for ch in string_input:
		for vow in vowel_list:
			if (ch ==vow):
				Vinstr+= [ch]
		for cons in consonant_list:
			if (ch == cons):
				Cinstr+= [ch]

	if(len(Vinstr)>=2):
		if(((Vinstr[0] and Vinstr[1]) == 'a') and (Cinstr[1] == 'h')):
			new_str=str(string_input).replace ('a','ea',2)
			new_str=new_str.strip("[ ,]")
			new_str=new_str.replace(",","")
			new_str=new_str.replace("'","")
			new_str =new_str.strip(" ")
			new_str=new_str.split(' ')
			return(new_str)

		else:	return(string_input)
	else:
		return (string_input)


# Open input and output files.

try:
	infile = open(sys.argv[1], "r")		# Open the input file in read mode

except:
	print("File '", sys.argv[1] ,"' not found!")


outfile = open(sys.argv[2], "w+")	# Open the output file in write mode
	

for word in infile:
	if(word =='\n'):
		break;			# For each line in the file
					# each line contains one word
	word = word.rstrip("\n")
	length_word = len(word)


	outfile.write(word + "\t")	# Write the hindi word

	prevChar = ''
	currChar = ''
	travFirstCh = False
	transWord = ""

	for ch in word:			#For each character in the current word

		currChar = ord(ch)
		
		il = hindiUni_to_Ilsl(currChar,1)
		
		if travFirstCh and not isMatra(currChar) and currChar != 0x094d and ch != "'" and ch != "_" and isConsonant(prevChar) :
			
			transWord += "a"

		transWord += il
		travFirstCh = True
		prevChar = currChar

	ilsl_seq = ' '.join(list(transWord))
	ilsl_seq = replacePhone(ilsl_seq)
	ilsl_seq=ilsl_seq.split(' ')

	ilsl_seq = rule_0_schwa_del (ilsl_seq) #rule 0 kehna
	
	ilsl_seq = rule1(ilsl_seq) #rule1: akabar: delete a between k and b

##################################################################################################################
#Rule 3:if the final vowel of the word is "a" and if this vowel is preceded by a cluster of consonants, replace "a"
# by "axx". Here, if c c a   (or   c c ), then replace "a" by "axx" (put “axx” after c c, i.e. c c axx)
#क्षेत्र	k sx ee t r
#-->
#क्षेत्र	k sx ee t r axx
##################################################################################################################	

	# Rule2 ::ksxeetr rule
	last_char=hindiUni_to_Ilsl(ilsl_seq[-1],0)
	last_second_char=hindiUni_to_Ilsl(ilsl_seq[-2],0)
	if(isConsonant(last_char) and isConsonant(last_second_char)):
		ilsl_seq+=" "+ "axx"

	
	
	ilsl_seq=str(ilsl_seq)
	ilsl_seq=ilsl_seq.strip("[ ,]")
	ilsl_seq=ilsl_seq.replace(",","")
	ilsl_seq=ilsl_seq.replace("'","")
	outfile.write(ilsl_seq +"\n")
	

infile.close();
outfile.close();


