import os
import math

path_csv = os.getenv('DATACSV')
print(path_csv)

csv_fn = os.listdir(path_csv)

csv = [file[:-18] for file in csv_fn if file[-7:]=='.csv.gz']
imp = [file[:-15] for file in csv_fn if file[-4:]=='.csv']

dup_files = [line + "-timeSeries.csv.gz" for line in csv if line in imp]

for fn in dup_files:
    fullfn = path_csv + fn
    print(fullfn)
    os.remove(fullfn)


