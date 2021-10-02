import os
import math


numFiles = 115

path_comm = os.getenv('DATACOMM')
path_csv = os.getenv('DATACSV')
path_Missing = os.getenv('DATAMISSING')
print(path_csv)

csv_fn = os.listdir(path_csv)
Missing_fn = os.listdir(path_Missing)

csv = [file[:-18] for file in csv_fn if file[-7:]=='.csv.gz']
Missing = [file[:-9] for file in Missing_fn if file[-4:]=='.csv']

new_cmds = [line + "-timeSeries.csv.gz" for line in csv if line not in Missing]

numLines = len(new_cmds)
print(numLines)
if numLines > 1:
    if numLines < numFiles:
        numFiles = numLines
    chunkLines = math.ceil(numLines/numFiles)
    if chunkLines>1:
        for i in range (numFiles):
            if i == 0:
                ln = new_cmds[i*chunkLines:(i+1)*chunkLines]
            else:
                ln = new_cmds[(i*chunkLines)+1:(i+1)*chunkLines]
            filename = path_comm +'/inputMissing_' + str(i) + '.txt'
            f = open(filename, 'w')
            f.writelines( "%s\n" % item for item in ln )
            f.close()
    else:            
        ln = new_cmds
        filename = path_comm +'/inputMissing_*.txt'
        f = open(filename, 'w')
        f.writelines( "%s\n" % item for item in ln )
        f.close()
