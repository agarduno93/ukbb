ukbb


To download bulk data we want: 
- Open command prompt
- Set directory 
- name file with datafiles (field_90001_NW5_UNREL) as input.txt OR select the amount of datafiles you want to download
- Type: ukbfetch -binput.txt -ak63099r43661.ukbkey

https://readthedocs.org/projects/biobankaccanalysis/downloads/pdf/latest/

To analyze cwa to csv: 
- Shift + enter - open linux shell here 
- Set directory 
- Type: python3 1_cwa_to_csv filename.cwa.gz

To prepare for nparact: 
- Run 2_npartact_prep 

To run nparACT
- Go to R-studio
- Open 3_nparACT 


D:\UKBiobank\Data


