import datetime
import sys
import os

path_baa = os.getenv('CODEBAA')
print(path_baa)
path_raw = os.getenv('DATARAW')
print(path_raw)
path_out = os.getenv('DATAOUTPUTS')
print(path_out)

sys.path.append(path_baa)


from accelerometer import accUtils
accUtils.writeStudyAccProcessCmds(path_raw,outDir=path_out,cmdsFile="processCmds.txt")

