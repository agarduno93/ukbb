import os
import math

numFiles = 115

path_comm = os.getenv('DATACOMM')
path_csv = os.getenv('DATACSV')
print(path_csv)

csv_fn = os.listdir(path_csv)

csv = [file[:-18] for file in csv_fn if file[-7:]=='.csv.gz']
imp = [file[:-15] for file in csv_fn if file[-4:]=='.csv']

new_cmds = [line + "-timeSeries.csv.gz" for line in csv if line not in imp]

numLines = len(new_cmds)
print(numLines)
if numLines > 0:
    if numLines < numFiles:
        numFiles = numLines
    chunkLines = math.ceil(numLines/numFiles)
    if chunkLines>1:
        for i in range (numFiles):
            if i == 0:
                ln = new_cmds[i*chunkLines:(i+1)*chunkLines]
            else:
                ln = new_cmds[(i*chunkLines)+1:(i+1)*chunkLines]
            filename = path_comm +'/inputImp_' + str(i) + '.txt'
            f = open(filename, 'w')
            f.writelines( "%s\n" % item for item in ln )
            f.close()
    else:            
        for i in range (numFiles):
            ln = new_cmds[i]
            filename = path_comm +'/inputImp_' + str(i) + '.txt'
            f = open(filename, 'w')
            f.writelines( ln )
            f.close()       
