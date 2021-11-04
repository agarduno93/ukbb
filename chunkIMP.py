import os
import math

numFiles = 115

path_comm = os.getenv('DATACOMM')
path_csv = os.getenv('DATACSV')
path_imp = os.getenv('DATAIMP')
print(path_csv)

csv_fn = os.listdir(path_csv)
imp_fn = os.listdir(path_imp)

csv = [file[:-18] for file in csv_fn if file[-7:]=='.csv.gz']
imp = [file[:-9] for file in imp_fn if file[-4:]=='.csv']

new_cmds = [line + "-timeSeries.csv.gz" for line in csv if line not in imp]

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
            filename = path_comm +'/inputImp_' + str(i) + '.txt'
            f = open(filename, 'w')
            f.writelines( "%s\n" % item for item in ln )
            f.close()
    else:            
        ln = new_cmds
        filename = path_comm +'/inputimp_*.txt'
        f = open(filename, 'w')
        f.writelines( "%s\n" % item for item in ln )
        f.close()
