#!/bin/bash

DIR=$1 #sequence fasta
OUT=$2      # xml with regions data

function utr5 {
    cd 5UTR/
    echo "${OUT} 5'UTR"

    prinseq-lite.pl -fasta *5UTR.fa -derep 1 -verbose -out_format 1 -out_good ${OUT}_norep 
    muscle -in ${OUT}_norep.fasta -clwstrict -out ${OUT}.aln    
    RNAz ${OUT}.aln | head -n 23
    RNAz ${OUT}.aln > ${OUT}.out
    RNAalifold -p ${OUT}.aln 

    pwd 

    # run cmount.pl
    perl ../../../../ViennaRNA-2.4.1/src/Utils/cmount.pl alidot.ps > ${OUT}_cmount.ps
    # run relplot.pl
    perl ../../../../ViennaRNA-2.4.1/src/Utils/relplot.pl alirna.ps alidot.ps > ${OUT}_relplot.ps
    # run coloraln.pl
    perl ../../../../ViennaRNA-2.4.1/src/Utils/coloraln.pl -s alirna.ps ${OUT}.aln > ${OUT}_coloraln.ps

    cd ..
}

function utr3 {
    pwd	
    cd 3UTR/
    for x in {1..3}
    do
        echo "${OUT} 3'UTR - R${x}"
        cd R${x}/
        prinseq-lite.pl -fasta ${OUT}_R${x}.fa -derep 1 -verbose -out_format 1 -out_good ${OUT}_R${x}_norep
        muscle -in ${OUT}_R${x}_norep.fasta -clwstrict -out ${OUT}_R${x}.aln    
        RNAz ${OUT}_R${x}.aln > ${OUT}_R${x}.out
        RNAz ${OUT}_R${x}.aln | head -n 23
        RNAalifold -p ${OUT}_R${x}.aln 

        # run cmount.pl
        perl ../../../../../ViennaRNA-2.4.1/src/Utils/cmount.pl alidot.ps > ${OUT}_R${x}_cmount.ps
        # run relplot.pl
        perl ../../../../../ViennaRNA-2.4.1/src/Utils/relplot.pl alirna.ps alidot.ps > ${OUT}_R${x}_relplot.ps
        # run coloraln.pl
        perl ../../../../../ViennaRNA-2.4.1/src/Utils/coloraln.pl -s alirna.ps ${OUT}_R${x}.aln > ${OUT}_R${x}_coloraln.ps

        cd ..
    done
}



echo "Run prinseq, muscle, RNAalifold and RNAz"
    cd ${DIR}/
    utr5
    utr3
    exit
