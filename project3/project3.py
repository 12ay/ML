#!/usr/local/bin/python

import os
import sys
import math
import nltk

from os import listdir
from os.path import isfile, join


# We need to find out how to import nltk.corpus
from nltk.corpus import wordnet

# import stop words

from nltk.corpus import stopwords
from nltk.corpus import wordnet

# This script inputs the labelled documents and outputs 
# the highest frequent words, the input paramater for the 
# script shows how many words to output



#nltk.download()
print(stopwords.words)

# Object Labeled files
labeledDirectory = sys.argv[1]
labeledFiles = [ f for f in listdir(labeledDirectory) if isfile(join(labeledDirectory, f))]

# Obtain unlabeled files 
unlabeledDirectory = sys.argv[2] 
unlabeledFiles = [ f for f in listdir(unlabeledDirectory) if isfile(join(unlabeledDirectory, f))]


# GET THE BAG OF WORDS IN THE LABELED FILE AND PUT THEM IN THE BAG OF WORDS MAP
wordsInFileMap = { }
unlabeledWordsInFileMap = { }

for fileName in labeledFiles :
	file = open(labeledDirectory + "/" + fileName,"r")
	wordSet = []
	wordsInFileMap[fileName] = wordSet
	#implement a word tokenizer within the loop
	for line in file:

		# Filter stop words either from the nltk set , or your own user defined set

		# Get onley the word, make sure it ia a word.
		# If it is a word and not a stop word then add it to the list 
		# temp.append(line.split())
		splitWords = line.split()
		for word in splitWords :
			if ( wordnet.synsets(word) and (word not in stopwords.words('english'))) :
			
				# realWord = wordnet.synsets(word)[0].lemma_names()[0]
				wordSet.append(word)
#print (wordSet)
	#print(wordsInFileMap[fileName])

# ITERATE OVER EACH SET OF LIST OF SELECTEDWORDSMAP[FILENAME], INCREMEMENT WORD COUNT FOR EACH WORD,
# EACH WORD REPRESENTS A KEY FROM THE DICTIONARY WORDMAP, EACH WORDLIST HAS A WORDMAP DICTIONARY

wordList = []
labeledListMap = {} 

class WordObject  :
	wordCount = 0
	word = ""
	def __init__(self, countParam,wordParam) :
		self.wordCount = countParam
		self.word = wordParam
		

for fileName in labeledFiles :
	# WORD MAP WILL COMPOSE OF THE WORD COUNT FOR EVERY DICTIONARY LOOK UP
	wordMap = {}
	wordList.append(wordMap)
	wordSetFromFile = wordsInFileMap[fileName]
	for word in wordSetFromFile :
		keys = wordMap.keys()

		if word in keys :
			wordMap[word] += 1
		else :
			wordMap[word] = 1
	
#	for wordKey, wordValue in wordMap.items() :
#		print("\n" + fileName + " + " + wordKey + " " + str(wordValue) + "\n") 

	finalList = []
	fullLabeledSet = set()
	labeledListMap[fileName] = fullLabeledSet
	for i in range(5) :
		highestCount = 0
		selectedKey = -1
		for wordKey, wordCount in wordMap.items() :
			if wordCount > highestCount :
				highestCount = wordCount
				selectedKey = wordKey

		wordObject = WordObject(highestCount, selectedKey)

		#print(fileName + " " + str(highestCount) + " " + selectedKey)
		# REMOVE FROM WORDMAP
		del wordMap[selectedKey]	
	
		finalList.append(wordObject)

		
	for word in finalList :
		for wordSetInst in wordnet.synsets(word.word) :
			for newWords in wordSetInst.lemma_names() :
				fullLabeledSet.add(newWords)	 
				#		wordSet = selectedWordsMap[fileName]
				#		wordSet.add(newWords)
		#print(fileName + " " + str(object.wordCount) + " " + object.word)

	#these 3 lines
	#for word in fullLabeledSet :
	#	print(fileName + " " + word)
	#print("\n")
	
		# put this wordValue in the finalSet with its synonyms , remove the selectedKey entry from the dictionary

 

# OPEN THE FILES FROM THE UNLABELED CORPUS
# for fileName in unlabeledFiles :
#	file = open(fileName,"r")
#	if (wn.synsets(word)) and (word not in stopwords.words("English")):
#		wordList.add(word)
'''
unlabeledWordSet = []
for fileName in unlabeledFiles:
	file = open(unlabeledDirectory + "/" + fileName, "r")
	for line in file:
		split = line.split()
		for word in split:
			#synsets(word.decode('utf-8')) doesn't work either
			if(wordnet.synsets(word) and (word not in stopwords.words('english'))):
				unlabeledWordSet.append(word)
'''
for fileName in unlabeledFiles :
	file = open(unlabeledDirectory + "/" + fileName,"r")
	unlabeledWordSet = []
	unlabeledWordsInFileMap[fileName] = unlabeledWordSet
	#implement a word tokenizer within the loop
	for line in file:

		# Filter stop words either from the nltk set , or your own user defined set

		# Get onley the word, make sure it ia a word.
		# If it is a word and not a stop word then add it to the list 
		# temp.append(line.split())
		splitWords = line.split()
		for word in splitWords :
			if ( wordnet.synsets(word.decode('utf-8')) and (word.decode('utf-8') not in stopwords.words('english'))) :
			
				# realWord = wordnet.synsets(word)[0].lemma_names()[0]
				unlabeledWordSet.append(word)

# Now we have a list of words in temp that are not stop words

# You can then perhaps a nltk command to get the frequency of a word
# If there is not nltk command then create a function to get the frequency of each word

#  FREQUENCY IS SPECIFIED BY:   (number of the word occurances ) / temp.length


# Ouput wordListCount number of words , along with its frequency
# [  together .15  computation .13   computer .10 ...     wordListaCount ]





	
#print(temp)

	
