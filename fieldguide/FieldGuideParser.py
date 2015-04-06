#!/usr/bin/python
import csv


class FieldGuideParser:

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

	@staticmethod
	def parseForbsSpecies(filename):
		with open(filename, 'rb') as csvfile:
			forbsreader = csv.reader(csvfile, delimiter=',', quotechar='"')
			forbsreader.next()
			species = []
			for row in forbsreader:
				fixed_row = []
				for item in row:
					fixed_row.append(item.strip().replace('\xe2\x80\x99' , "'")) # replaces non-ascii apostrophe with ascii apostrophe. It is sometimes present in csv files created from .xlsx extensions in place of "'" and python doesn't like it
				species.append(fixed_row)
			return species

# # print FieldGuideParser.parseGlossaryTerms('GlossaryTerms.csv')
# for species in FieldGuideParser.parseForbsSpecies('Forbs.csv'):
# 	print species