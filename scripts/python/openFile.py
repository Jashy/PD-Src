#!/usr/bin/python3

import re
import gzip

def read_file(filename):
	if re.match(r'.*\.gz',filename):
		with gzip.open(filename,'rt',encoding='utf-8') as fo:
			fo_read = fo.read()
	else:
		with open(filename) as fo:
			fo_read = fo.read()
	return fo_read

def readlines_file(filename):
	if re.match(r'.*\.gz',filename):
		with gzip.open(filename,'rt',encoding='utf-8') as fo:
			fo_readlines = fo.readlines()
	else:
		with open(filename) as fo:
			fo_readlines = fo.readlines()
	return fo_readlines