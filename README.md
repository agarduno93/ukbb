ukbb

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
