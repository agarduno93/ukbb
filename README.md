## ukbb SHerlock Pipeline

The data processing pipeline is broken down into 3 main steps:
 1. Download data from UKBB
	- Run the getData.txt script -make sure paths are what you want
 2. Convert data from .cwa to .csv
	- Download biobankAccelerometryAnalysis
	- Run the CWA2CSV.txt script to submit jobs -make sure paths are what you want
 3. Calculate IVIS from .csv
	- Run CSV2IVIS.txt script -make sure paths are what you want
 4. Determine amount of missing data
	- Run CSV2MISSING.txt script -make sure paths are what you want
Note: See the lab google doc for more detailed info

## Prerequisites
Stanford only: Ask Jamie to email srcc-support@stanford.edu to get a sherlock account. Provide your SUNet ID. 

## Sherlock OnDemand
Stanford only: Use this online portal to access Sherlock. The genetics cluster also has an online portal. If onDemand is not available for the computing cluster you’re connecting to, use Mobaxterm or connect to the cluster from the shell.

## Connecting Sherlock to Github
See this page. Run commands in the terminal after logging into Sherlock. Note: you may need to generate a personal access token to access git from sherlock. This will function as your password when requesting to pull/push from/to github

## Download UKBB Data
 1. Generate the input file from the UKBB online database. This is a text file containing the participant ID and field ID. This can be extracted with filters such as “no missing data” from the UKBB website. Also extract the key, bulk, and ukbfetch files.

 2. Place the input file into the commands folder and the bulk, key, and ukbfetch into the raw data folder. Note: To make ukbfetch an executable you may need to run

chmod 777 ukbfetch  

 3. To submit batch jobs to download data go back to the code folder and run 

bash getData.txt 

Note: sometimes only the input files are segmented rather than running the entire code. It usually runs fully if you copy and paste the loop within the shell script into the command line. I have no idea why. 

 4. Check to make sure the correct number of files has been downloaded. Use the inputMod.py code to check to see if the expected flies have been run. This code will update the input files

Repeat steps 3 and 4 as necessary. Some reasons that repeating may be necessary (1) the jobs failed, (2) trying to download from more than 10 parallel computers at a time, (3) participants have withdrawn and data is no longer available.  

## Convert .cwa files to .csv
 1. Download the biobankAccelerometerAnalysis toolbox from github

git clone https://github.com/ZeitzerLab/biobankAccelerometerAnalysis.git 
cd biobankAccelerometerAnalysis

 2. Run the following command from the ukbb folder to download modules, generate process commands, and convert files into .csvs. NOTE: Paths will need to be set within this file.

bash CWA2CSV.txt 

 3. Check to see if the files ran completely. We occasionally ran into instances where a job was canceled.

## Unzip the .csv files
 1. Run the following command. NOTE: Paths will need to be set within this file.

sbatch -n 1 -t 1-00:00:00 --job-name=GZ2CSV --wrap="bash /scratch/groups/jzeitzer/UKBB/Code/ukbb/GZ2CSV.txt"

 2. Check to see if the files ran completely. We occasionally ran into instances where a job was canceled.

 3. Run the following command to remove .gz files while keeping .csvs. NOTE: Paths will need to be set within this file.

python3 exIMP.py

## Run Median Imputation Code & Calculate Median Day
 1. Run the following command. NOTE: Paths will need to be set within this file.

bash CSV2MEDDAY.txt 

## Run IVIS (nparACT) code
 1. Run the following command. NOTE: Paths will need to be set within this file.

bash CSV2IVIS.txt 

## Appendix
## Basics and Navigating in the Terminal
ls - Used to see files within your current directory
Ls <folder> - Used to see files within a different folder
pwd - Used to determine your current working directory
cd - Used to navigate to your base directory
cd <folder> - Used to navigate to a specific folder
cd .. - Used to navigate up one folder level
mkdir <folder> - Used to make a new folder in a specific location
touch <filename>  - Used to create a new empty file
mv <filename> <folder> - Used to move a file to a specific location
mv <filename> <new filename> - Used to rename a file
cp <filename> - Used to copy a file
cp <filename> <new filename> - Used to make a copy of a file with a new name
edit <filename> - Used to open a file in a text editor
vim <filename> - Used to open file in vim text editor
nano <filename> - Used to open file in nano text editor

## Run missing data characterization code
 1. Install the R package dplyr

 2. Run the following command - make sure paths are correct and that proper missing data algorithm is called. There’s a missing data check that determines the total missing data and a missing data length check that determines the number of chunks of missing data and their length 

bash CSV2MISSING.txt 

 3. Run compilation code to put all outputs in a single file - make sure paths are correct

bash stitchCSV.txt

## Download Data from sherlock onto External drive
 1. Open mobaxterm shell and navigate to external drive in shell

 2. Run this command to download files from sherlock to external drive

rsync -avP laraweed@dtn.sherlock.stanford.edu:/scratch/groups/jzeitzer/UKBB?Data/Outputs/Batch_fullfiles/timeSeries/ .

 3. The following command may be necessary to adjust the permissions on the files after they are downloaded, otherwise they may not be able to be executed upon

chmod 777 <filename>

## Files greater than 2000
 1. Check to see if there are files with acceleration greater than 2000 

sbatch -n 1 -t 1-00:00:00 --job-name=MoreThan2000 --wrap="R --save < index2000.R”
