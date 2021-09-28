# Modify process commands in case some files were skipped

import os

path_comm = os.getenv('DATACOMM')
print(path_comm)
path_raw = os.getenv('DATARAW')
print(path_raw)
path_out = os.getenv('DATAOUTPUTS')
print(path_out)
path_csv = path_out + "/timeSeries"
print(path_csv)

filenames = os.listdir(path_csv)

csv = [file[:-28] for file in filenames if file[-7:]=='.csv.gz']
print(csv[:5])

if csv:
    fn = path_comm + '/processCmds.txt'
    print(fn)
    myfile = open(fn,"r")
    lines=myfile.readlines()
    print('Original Num Lines:' + str(len(lines)))
    myfile.close()
    #print(lines[1][24+len(path_raw):24+len(path_raw)+7])
    new_lines = [line for line in lines if line[24+len(path_raw):24+len(path_raw)+7] not in csv]
    print('New Num Lines:' + str(len(new_lines)))
    #print(new_lines[1][24+len(path_raw):24+len(path_raw)+7])
    new_file = open(fn, "w")
    for nl in new_lines:
        new_file.write(nl)
    new_file.close()
