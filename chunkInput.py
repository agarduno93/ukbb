import os
import math

inputfile = os.getenv('INPUT')
path_comm = os.getenv('DATACOMM')
path_raw = os.getenv('DATARAW')

with open(inputfile) as myfile:
    firstNlines=myfile.readlines()

cwa_fn = os.listdir(path_raw)

cwa = [file[:-4] for file in cwa_fn if file[-4:]=='.cwa']
inputs = [file[:7]+"_"+file[8:-1] for file in firstNlines]

new_inputs = [line[:7] + '\t' + line[8:] + '\n' for line in inputs if line not in cwa]

numLines = len(new_inputs)
numFiles = math.ceil(numLines/1000) # max of 1000 files per batch download thorugh ukbb command
chunkLines = math.ceil(numLines/numFiles)

for i in range (numFiles):
    if i == 0:
        ln = new_inputs[i*chunkLines:(i+1)*chunkLines]
    else:
        ln = new_inputs[(i*chunkLines)+1:(i+1)*chunkLines]
    #print(ln)
    filename = path_raw + 'input_' + str(i) + '.txt'
    f = open(filename, 'w')          
    f.writelines( "%s" % item for item in ln )
    f.close()

os.environ["NUMINPUT"] = str(chunkLines)
