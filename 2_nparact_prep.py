import pandas as pd
import os

def convertForNPARact(pathfolder, destination):
	for filename in os.listdir(pathfolder):
		print(filename)
		df = pd.read_csv(pathfolder + filename)
		for i in range(len(df["time"])):
			date = str(df.at[i, "time"]).split(" ")[0]
			# date = str(str(date).replace("-", "/"))
			t = str(df.at[i, "time"]).split(" ")[1].split(".")[0]
			df.at[i, "time"] = f"{date} {t}"

		# 2014-05-29T10:15:00-0700
		df = df.drop(["imputed", "MVPA", "light", "sedentary", "sleep", "MET"], axis=1)

		df.to_csv(destination + "//" + "nparactformat_" + filename, header=False, index=False)


convertForNPARact("/scratch/groups/jzeitzer/UKBB/Data/Outputs/Batch_test/timeSeries/", "/scratch/groups/jzeitzer/UKBB/Data/CSV/Batch_test/")
