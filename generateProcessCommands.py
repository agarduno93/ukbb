import datetime
import sys
import os

path_baa = os.getenv('CODEBAA')
path_raw = os.getenv('DATARAW')
path_out = os.getenv('DATAOUTPUTS')

sys.path.append(path_baa)


from accelerometer import accUtils
accUtils.writeStudyAccProcessCmds(path_raw,outDir=path_out,cmdsFile="processCmds.txt")

