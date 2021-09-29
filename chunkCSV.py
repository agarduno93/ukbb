import os
import math

numFiles = 115

path_comm = os.getenv('DATACOMM')
path_csv = os.getenv('DATACSV')
print(path_csv)

files = os.listdir(path_csv)

numLines = len(files)
numFiles = 115
if numLines < numFiles:
    numFiles = numLines
chunkLines = math.ceil(numLines/numFiles)

for i in range (numFiles):
    if i == 0:
        ln = files[i*chunkLines:(i+1)*chunkLines]
    else:
        ln = files[(i*chunkLines)+1:(i+1)*chunkLines]
    #print(ln)
    filename = path_comm +'/inputcsv_' + str(i) + '.txt'
    f = open(filename, 'w')
    f.writelines( "%s\n" % item for item in ln )
    f.close()
