#!/usr/bin/python
import csv

"""
This file contains static methods for parsing the Forbs species and Glossary Terms 
spreadsheets. These sheets should be .csv format and be in the same directory as this
file will be run in.
"""
class FieldGuideParser:


	"""
	parses the glossary terms and stores them in a dictionary with the term type as key
	and the list of terms as value
	"""
	@staticmethod
	def parseGlossaryTerms(filename):
		with open(filename, 'rb') as csvfile:
			glossarytermsreader = csv.reader(csvfile, delimiter=',', quotechar='|')
			headers = glossarytermsreader.next()
			terms = {}
			for header in headers:
				terms[header.strip()] = []
			for row in glossarytermsreader:
				i = 0
				for header in headers:
					if row[i] != '':
						terms[header.strip()].append(row[i].strip())
					i+=1
			return terms

	"""
	parses the Forbs species and stores them in a list of lists. Each list is equivalent
	to a full row in the spreadsheet. Column names are not stored
	"""
	@staticmethod
	def parseForbsSpecies(filename):
		with open(filename, 'rb') as csvfile:
			forbsreader = csv.reader(csvfile, delimiter=',', quotechar='"')
			forbsreader.next() # skip the headers
			species = []
			for row in forbsreader:
				fixed_row = []
				for item in row:
					fixed_row.append(item.strip().replace('\xe2\x80\x99' , "'")) # replaces non-ascii apostrophe with ascii apostrophe. It is sometimes present in csv files created from .xlsx extensions in place of "'" and python doesn't like it
				species.append(fixed_row)
			return species