# [A Workflow for Predicting MicroRNAs Targets via Accessibility in Flavivirus Genomes](https://link.springer.com/chapter/10.1007/978-3-030-01722-4_12) 
## Resume 
Flavivirus infections are a serious public health issue in Brazil, particularly in recent years due to the large number and severity of cases of Zika and Dengue virus infections and, more recently, outbreaks of Yellow Fever virus infections. Therefore, understanding the effects of genetic variations at functional and structural levels and developing new tools are necessary for supporting arboviral surveillance and control efforts of these viruses. In this context, we developed a workflow to predict potential microRNA targets in Flavivirus genomes. The workflow implementation comprised the integration of Perl scripts, tools from ViennaRNA package, and miRanda software to search for potential microRNAs that potentially interact with non-coding regions of Flavivirus genomes. As a case study, genome sequences of Dengue virus serotypes were used. We could observe structural differences among the serotype sequences and  miRNA target binding sites exclusively identified for each serotype, which may be useful for the development of diagnostic methods.
# Scripts and data to caracterize arboviroses secondary structure
## Scripts
Exists perl scripts (.pl) to manipulate the content of
files and bash scripts (.sh) to automatize execution

### XMLparser.pl
	This program parse a XML file, extracting the ID, total length,      
	3`UTR length or 5'UTR length and cds position.                      
	INPUT: XMLparser.pl file.xml output.txt 100                          
	OUTPUT: output.txt (ID utr-length cds-position)

### select_utr.pl
	This program has as input the output of XMLparser and selects only	
	utr region with a specific size. this helps to align only same size 
	sequences.															
	INPUT: select_utr.pl output-xmlparser.txt                           
	OUTPUT: output.txt							

### get5UTR.pl
	This program uses a fasta file, ids and cds length (select_utr.pl)
	to generate a output with the sequence 5'UTR region only.		       	
	INPUT: get_5UTR.pl sequence.fa output_xml.txt                         	
	OUTPUT: virus_5UTR.fa 							

### get3UTR.pl
	This program uses a fasta file, ids and cds length (select_utr.pl)
	to generate a output with the sequence 3'UTR region only.		       	
	INPUT: get_3UTR.pl sequence.fa output_xml.txt                         	
	OUTPUT: virus_3UTR.fa 							

### select_regions.pl
	This program parse fasta file and divided in 3 regions a genome 
	sequence, the size of each on is determined by input.               
	INPUT: select_regions.pl sequence.fa output.txt reg2 reg3
	OUTPUT: output_R1.fa  output_R2.fa output_R3.fa                                                                  

### formats_targetinfo.pl
	This program format a mirna family info file to a target scan format
	INPUT: formats_targetinfo.pl miR_familyinfo.txt output.txt
	OUTPUT: output.txt

### autorun.sh
	Runs all scripts get only non coding regions                
	INPUT: .\autorun.sh full_sequence.fasta                     
		xml_with_regions_data/genbank-file minimum-nucleotides     

### images.sh
	This script rusn all programs to generate secondary structure images        
	Remove redundancy in sequences (prinseq-lite.pl), multiple align (muscle),  
	RNAz, RNAfold and perl script to generate images                            

### get_consensus.sh
	This program selects RNAz consensus sequence, remove gaps,              
	and writes all virus consensus sequences in targets/. Also              
	generate secondary structure and target scan file.                      
	INPUT: ./get_consensus.sh                                                






## Data
All data is in a directory data/ and has subdirectories for each virus. 

	Yellow fever virus	-> YFV/ 
	Zika virus		-> ZIKV/ 
	Dengue sorotype 1	-> denv1/ 
	Dengue sorotype 2	-> denv2/ 
	Dengue sorotype 3	-> denv3/ 
	Dengue sorotype 4	-> denv4/

And each subdirectory has directories for targets predictions 
and non coding regions 5'UTR, 3'UTR.
The 3'UTR directory has informations of each subregion (R1/ R2/ R3/)

