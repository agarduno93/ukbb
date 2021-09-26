import datetime
import sys
sys.path.append("/scratch/groups/jzeitzer/UKBB/Code/biobankAccelerometerAnalysis/")


from accelerometer import accUtils
accUtils.writeStudyAccProcessCmds(
"/scratch/groups/jzeitzer/UKBB/Data/Raw/Batch_fullfile/",
outDir="/scratch/groups/jzeitzer/UKBB/Data/Outputs/Batch_fullfile/",
cmdsFile="processCmds.txt"
)

