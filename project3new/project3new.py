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

		# Get only the word, make sure it ia a word.
		# If it is a word and not a stop word then add it to the list 
		# temp.append(line.split())
		splitWords = line.split()
		for word in splitWords :
			if ( wordnet.synsets(word) and (word not in stopwords.words('english'))) :
			
				# realWord = wordnet.synsets(word)[0].lemma_names()[0]
				wordSet.append(word)

# ITERATE OVER EACH SET OF LIST OF SELECTEDWORDSMAP[FILENAME], INCREMEMENT WORD COUNT FOR EACH WORD,
# EACH WORD REPRESENTS A KEY FROM THE DICTIONARY WORDMAP, EACH WORDLIST HAS A WORDMAP DICTIONARY

wordList = []
unlabeledWordList = []
labeledListMap = {} 
unlabeledListMap = {}

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

	finalList = []
	fullLabeledSet = set()
	labeledListMap[fileName] = fullLabeledSet
	#top 5 words
	for i in range(5) :
		highestCount = 0
		selectedKey = -1
		for wordKey, wordCount in wordMap.items() :
			if wordCount > highestCount :
				highestCount = wordCount
				selectedKey = wordKey
		wordObject = WordObject(highestCount, selectedKey)
		
		print('In ' +fileName + ', "' + selectedKey + '" appeared ' +str(highestCount) + ' times')
		del wordMap[selectedKey]	
	
		finalList.append(wordObject)
		

		
	for word in finalList :
		for wordSetInst in wordnet.synsets(word.word) :
			for newWords in wordSetInst.lemma_names() :
				fullLabeledSet.add(newWords)	 


for fileName in unlabeledFiles :
	file = open(unlabeledDirectory + "/" + fileName,"r")
	unlabeledWordSet = []
	unlabeledWordsInFileMap[fileName] = unlabeledWordSet
	#implement a word tokenizer within the loop
	for line in file:
		# Get only the word, make sure it ia a word.
		# If it is a word and not a stop word then add it to the list 
		splitWords = line.split()
		for word in splitWords :
			if (( wordnet.synsets(word)) and (word not in stopwords.words('english'))) :
				unlabeledWordSet.append(word)
	#print(unlabeledWordSet)
	#print(unlabeledWordsInFileMap[fileName])
	

	# repeat of above, but for the unlabeled files this time
	unlabeledWordMap = {}
	unlabeledWordList.append(unlabeledWordMap)
	wordSetFromFile = unlabeledWordsInFileMap[fileName]
	for word in wordSetFromFile :
		keys = unlabeledWordMap.keys()

		if word in keys :
			unlabeledWordMap[word] += 1
		else :
			unlabeledWordMap[word] = 1
			
	finalList = []
	fullLabeledSet = set()
	unlabeledListMap[fileName] = fullLabeledSet
	#top 5 words
	for i in range(5) :
		highestCount = 0
		selectedKey = -1
		for wordKey, wordCount in unlabeledWordMap.items() :
			if wordCount > highestCount :
				highestCount = wordCount
				selectedKey = wordKey

		wordObject = WordObject(highestCount, selectedKey)
		
		print('In ' +fileName + ', "' + selectedKey + '" appeared ' +str(highestCount) + ' times')
		
		del unlabeledWordMap[selectedKey]	
	
		finalList.append(wordObject)	
