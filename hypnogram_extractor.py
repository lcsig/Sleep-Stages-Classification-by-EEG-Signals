#!/usr/bin/env python3
import pyedflib
import os
import sys

print(sys.argv[1])

for fileName in os.listdir(sys.argv[1]):
	if fileName.endswith("-Hypnogram.edf"):
		filePath = os.path.join(sys.argv[1], fileName)
		f = pyedflib.EdfReader(filePath)
		annotations1 = f.readAnnotations()
		filePath = filePath.replace("-Hypnogram.edf", ".csv")
		with open(filePath, 'w') as fileCSV:
			for d in range(len(annotations1[0])):
				fileCSV.write(str(annotations1[0][d])+','+str(annotations1[1][d])+','+ annotations1[2][d].replace("Sleep stage ", "") + '\n')
