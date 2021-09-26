import math

numFiles = 115

with open("processCmds.txt") as myfile:
    firstNlines=myfile.readlines()#[0:5] #put here the interval you want

numLines = len(firstNlines)
chunkLines = math.ceil(numLines/numFiles)

for i in range (numFiles):
    if i == 0:
        ln = firstNlines[i*chunkLines:(i+1)*chunkLines]
    else:
        ln = firstNlines[(i*chunkLines)+1:(i+1)*chunkLines]
    #print(ln)
    filename = 'processCmds_' + str(i) + '.txt'
    f = open(filename, 'w')          
    f.writelines( "%s" % item for item in ln )
    f.close()
