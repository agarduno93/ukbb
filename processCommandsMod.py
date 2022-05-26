# Modify process commands in case some files were skipped

# Imports
import os
import math

# Get environment variables
path_comm = os.getenv('DATACOMM')
path_raw = os.getenv('DATARAW')
path_out = os.getenv('DATAOUTPUTS')
path_csv = path_out + "/timeSeries"

# Get current existing files 
cwa_fn = os.listdir(path_raw)
csv_fn = os.listdir(path_csv)

# Only select certain file types
cwa = [file[:-4] for file in cwa_fn if file[-4:]=='.cwa']
csv_1 = [file[:-18] for file in csv_fn if file[-7:]=='.csv.gz']
csv_2 = [file[:-15] for file in csv_fn if file[-4:]=='.csv']
csv = csv_1 + csv_2


# Select cwa files that have not already been converted
new_cmds = [line + ".cwa" for line in cwa if line not in csv]

# Generate all process commands
sumfol = "\"" +path_out + "/summary" + "\""
epfol =  "\"" +path_out + "/epoch" + "\""
tsfol =  "\"" +path_out + "/timeSeries" + "\""
nwfol =  "\"" +path_out + "/nonWear" + "\""
sfol =  "\"" +path_out + "/stationary" + "\""
rawfol =  "\"" +path_out + "/raw" + "\""
npyfol =  "\"" +path_out + "/npy" + "\""
proCmds = []
print("New Lines")
for nl in new_cmds:
    fullfn = "\"" +path_raw + "/" +  nl + "\""
    new_line = "python3 accProcess.py " + fullfn + " --summaryFolder " + sumfol + " --epochFolder " + epfol + " --timeSeriesFolder " + tsfol + " --nonWearFolder " + nwfol + " --stationaryFolder " + sfol + " --rawFolder " + rawfol + " --npyFolder " + npyfol + " --outputFolder " + path_out + "\n"
    proCmds.append(new_line)

# Determine number of files for parallelization
numLines = len(proCmds)
print("Files: " + str(numLines))
numFiles = 115
if numLines > 0:
    if numLines < numFiles:
        numFiles = numLines
    chunkLines = math.ceil(numLines/numFiles)
    if chunkLines>1:
        for i in range (numFiles):
            if i == 0:
                ln = proCmds[i*chunkLines:(i+1)*chunkLines]
            else:
                ln = proCmds[(i*chunkLines)+1:(i+1)*chunkLines]
            filename = path_comm +'/processCmds_' + str(i) + '.txt'
            f = open(filename, 'w')
            f.writelines( "%s\n" % item for item in ln )
            f.close()
    else:
        for i in range (numFiles):
            ln = proCmds[i]
            filename = path_comm +'/processCmds_' + str(i) + '.txt'
            f = open(filename, 'w')
            f.writelines( ln )
            f.close()




