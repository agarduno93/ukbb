import os
import math

numFiles = 115

path_comm = os.getenv('DATACOMM')
path_csv = os.getenv('DATACSV')
path_cos = os.getenv('DATACOS')
print(path_csv)

csv_fn = os.listdir(path_csv)
cos_fn = os.listdir(path_cos)

csv = [file[:-15] for file in csv_fn if file[-4:]=='.csv']
cos = [file[:-12] for file in cos_fn if file[-4:]=='.csv']

new_cmds = [line + "-timeSeries.csv" for line in csv if line not in cos]

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
            filename = path_comm +'/inputcos_' + str(i) + '.txt'
            f = open(filename, 'w')
            f.writelines( "%s\n" % item for item in ln )
            f.close()
    else:            
        ln = new_cmds
        filename = path_comm +'/inputcos_1.txt'
        f = open(filename, 'w')
        f.writelines( "%s\n" % item for item in ln )
        f.close()
