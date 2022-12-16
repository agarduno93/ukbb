#!/usr/bin/env python
# coding: utf-8

# ## Generalize MedDay Program

# In[64]:


import os
import math

numFiles = 3

#path_comm = os.getenv('DATACOMM')
#path_csv = os.getenv('DATACSV')
#path_szn = os.getenv('DATAMEDDAY')
#print(path_csv)


# In[65]:


path_comm = r"C:\Users\Alexis Garduno\Dropbox\WHI_RAR_Accelerometry\Commands"
path_csv = r"C:\Users\Alexis Garduno\Dropbox\WHI_RAR_Accelerometry\DATACSV"
path_szn = r"C:\Users\Alexis Garduno\Dropbox\WHI_RAR_Accelerometry\Data\MedDay"
print(path_csv)


# In[66]:


csv_fn = os.listdir(path_csv)
print(csv_fn)
medday_fn = os.listdir(path_szn)
print(path_szn)


# In[67]:


#edit the file name to truncate the filename
csv = [file[:-4] for file in csv_fn if file[-4:]=='.csv']
csv


# In[68]:


csv = [file[:-4] for file in csv_fn if file[-4:]=='.csv']
medday = [file[:-4] for file in medday_fn if file[-4:]=='.csv']

new_cmds = [line + "-timeSeries.csv" for line in csv if line not in medday]
print(new_cmds)

numLines = len(new_cmds)
print(numLines)
if numLines > 0:
    if numLines < numFiles:
        numFiles = numLines
    chunkLines = math.ceil(numLines/numFiles)
    if chunkLines>1:
        for i in range (numFiles):
            if i == 0:
                ln = new_cmds[i*chunkLines:(i+1)*chunkLines]
            else:
                ln = new_cmds[(i*chunkLines)+1:(i+1)*chunkLines]
            file_ext = 'inputMedDay_' + str(i) + '.txt'
            filename = os.path.join(path_comm, file_ext) 
            f = open(filename, 'w')
            f.writelines( "%s\n" % item for item in ln )
            f.close()
    else:            
        for i in range (numFiles):
            ln = new_cmds[i]
            file_ext = 'inputMedDay_' + str(i) + '.txt'
            filename = os.path.join(path_comm, file_ext) 
            f = open(filename, 'w')
            f.writelines( ln )
            f.close()


# In[ ]:




