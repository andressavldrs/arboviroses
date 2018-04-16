#################################################################################
#                                                                               #
#   This script rusn all programs to generate secondary structure images        #
#   Remove redundancy in sequences (prinseq-lite.pl), multiple align (muscle),  #
#   RNAz, RNAfold and perl script to generate images                            #
#################################################################################

#!/bin/bash

readonly DIR=$1 #sequence fasta
readonly OUT=$2 # xml with regions data

function utr5 {
    local reg="${DIR}/5UTR"
    echo "${OUT} 5'UTR"

    #prinseq-lite.pl -fasta *5UTR.fa -derep 1 -verbose -out_format 1 -out_good ${OUT}_norep 
    muscle -in ${reg}/${OUT}_norep.fasta -clwstrict -out ${reg}/${OUT}.aln    
    RNAz ${reg}/${OUT}.aln | head -n 23
    RNAz ${reg}/${OUT}.aln > ${reg}/${OUT}.out
    RNAalifold -p ${reg}/${OUT}.aln 

    pwd 

    # run cmount.pl
    perl cmount.pl ${reg}/alidot.ps > ${reg}/${OUT}_cmount.ps
    # run relplot.pl
    perl relplot.pl ${reg}/alirna.ps ${reg}/alidot.ps > ${reg}/${OUT}_relplot.ps
    # run coloraln.pl
    perl coloraln.pl -s ${reg}/alirna.ps ${reg}/${OUT}.aln > ${reg}/${OUT}_coloraln.ps

}

function utr3 {
    pwd	
    for x in {1..3}
    do
        echo "${OUT} 3'UTR - R${x}"
        local reg="${DIR}/3UTR/R${x}"

        #prinseq-lite.pl -fasta ${OUT}_R${x}.fa -derep 1 -verbose -out_format 1 -out_good ${OUT}_R${x}_norep
        muscle -in ${reg}/${OUT}_R${x}_norep.fasta -clwstrict -out ${reg}/${OUT}_R${x}.aln    
        RNAz ${reg}/${OUT}_R${x}.aln > ${reg}/${OUT}_R${x}.out
        RNAz ${reg}/${OUT}_R${x}.aln | head -n 23
        RNAalifold -p ${reg}/${OUT}_R${x}.aln 

        # run cmount.pl
        perl cmount.pl ${reg}/alidot.ps > ${reg}/${OUT}_R${x}_cmount.ps
        # run relplot.pl
        perl relplot.pl ${reg}/alirna.ps alidot.ps > ${reg}/${OUT}_R${x}_relplot.ps
        # run coloraln.pl
        perl coloraln.pl -s alirna.ps ${reg}/${OUT}_R${x}.aln > ${reg}/${OUT}_R${x}_coloraln.ps

    done
}



echo "Run prinseq, muscle, RNAalifold and RNAz"
    utr5
    utr3
    exit
