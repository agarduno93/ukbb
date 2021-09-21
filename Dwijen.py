import datetime
import sys
sys.path.append("/scratch/groups/jzeitzer/UKBB/Code/biobankAccelerometerAnalysis/")


from accelerometer import accUtils
accUtils.writeStudyAccProcessCmds(
"/scratch/groups/jzeitzer/UKBB/Data/Raw/Batch_test/",
outDir="/scratch/groups/jzeitzer/UKBB/Data/Outputs/Batch_test/",
cmdsFile="process-cmds_Batch_test.txt"
)

