ukbb

The data processing pipeline is broken down into 3 main steps:
 1. Download data from UKBB
	- Pipeline functional but needs to be written to main script
 2. Convert data from .cwa to .csv
	- Download biobankAccelerometryAnalysis
	- Run the CWA2CSV.txt script to submit jobs
 3. Calculate IVIS from .csv
	- In progress

Note: See the lab google doc for more detailed info


Archive:
To analyze cwa to csv: 
- Shift + enter - open linux shell here 
- Set directory 
- Type: python3 1_cwa_to_csv filename.cwa.gz

To run nparACT
- Go to R-studio
- Open 3_nparACT 


