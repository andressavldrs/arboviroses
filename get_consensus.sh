#############################################################################
#   This program selects RNAz consensus sequence, remove gaps,              #
#   and writes all virus consensus sequences in targets/. Also              #
#   generate secondary structure and target scan file.                      #
#  INPUT: ./get_consensus.sh                                                #
#############################################################################

#!/bin/bash

function denv {
    for x in {1..4}
    do
        #open denv/5utr directory
        cd denv${x}/5UTR/
        rm ../targets/*.*
        # fasta sequence without gaps    
        echo ">5UTR" >> ../targets/consensus_denv${x}.fa
        consensus=$(perl -ne 'print if $,;$, = />consensus/' denv${x}.out | sed -e 's/_//g')
        echo $consensus  >> ../targets/consensus_denv${x}.fa


        # Bracket dot structure
        echo ">5UTR" >> ../targets/consensus_denv${x}.fold
        echo $consensus | RNAfold -p >> ../targets/consensus_denv${x}.fold

        # Target scan format
        echo -n "5UTR 9606  " >> ../targets/ts_denv${x}.txt
        echo $consensus >> ../targets/ts_denv${x}.txt

        #open denv/3utr directory
        cd ../3UTR/
        for y in {1..3}
        do
            # do it for each region
            cd R${y}/
            # fasta sequence without gaps
            echo ">R${y}" >> ../../targets/consensus_denv${x}.fa
            
            consensus=$(perl -ne 'print if $,;$, = />consensus/' denv${x}_R${y}.out| sed -e 's/_//g')
            echo $consensus  >> ../../targets/consensus_denv${x}.fa

            # Bracket dot structure
            echo ">R${y}" >> ../../targets/consensus_denv${x}.fold
            echo $consensus | RNAfold -p  >> ../../targets/consensus_denv${x}.fold

            # Target scan format
            echo -n "R${y} 9606    " >> ../../targets/ts_denv${x}.txt
            echo $consensus >> ../../targets/ts_denv${x}.txt

            cd ..
        done
        #go back to data/0
        cd ../../
    done
}

function yfv {
        #open denv/5utr directory
        cd YFV/5UTR/
        rm ../targets/*.*

        # fasta sequence without gaps
        echo ">5UTR" >> ../targets/consensus_yfv.fa

        consensus=$(perl -ne 'print if $,;$, = />consensus/' yfv.out | sed -e 's/_//g')
        echo $consensus >> ../targets/consensus_yfv.fa
                
        # Bracket dot structure
        echo ">5UTR" >> ../targets/consensus_yfv.fold
        echo $consensus | RNAfold -p >> ../targets/consensus_yfv.fold

         # Target scan format
        echo -n "5UTR 9606    " >> ../targets/ts_yfv.txt
        echo $consensus >> ../targets/ts_yfv.txt

        #open denv/3utr directory
        cd ../3UTR
        for y in {1..3}
        do
            # do it for each region
            cd R${y}/
            # fasta sequence without gaps
            echo ">R${y}" >> ../../targets/consensus_yfv.fa

            consensus=$(perl -ne 'print if $,;$, = />consensus/' yfv_R${y}.out | sed -e 's/_//g')
            echo $consensus >> ../../targets/consensus_yfv.fa  

            # Bracket dot structure
            echo ">R${y}" >> ../../targets/consensus_yfv.fold
            echo $consensus | RNAfold -p >> ../../targets/consensus_yfv.fold

            # Target scan format
            echo -n "R${y} 9606    " >> ../../targets/ts_yfv.txt
            echo $consensus >> ../../targets/ts_yfv.txt
            cd ..
        done
        #go back to data/
        cd ../../
}

function zikv {
        #open denv/5utr directory
        cd ZIKV/5UTR/
        # Clear previous files
        rm ../targets/*.* 
        
        # fasta sequence without gaps
        echo ">5UTR" >> ../targets/consensus_zikv.fa

        consensus=$(perl -ne 'print if $,;$, = />consensus/' zikv.out | sed -e 's/_//g')
        echo $consensus >> ../targets/consensus_zikv.fa

        # Bracket dot structure
        echo ">5UTR" >> ../targets/consensus_zikv.fold
        echo $consensus | RNAfold -p >> ../targets/consensus_zikv.fold

        # Target scan format
        echo -n "5UTR 9606    " >> ../targets/ts_zikv.txt
        echo $consensus >> ../targets/ts_zikv.txt

        #open denv/3utr directory
        cd ../3UTR
        for y in {1..3}
        do
            # do it for each region
            cd R${y}/
            # fasta sequence without gaps
            echo ">R${y}" >> ../../targets/consensus_zikv.fa

            consensus=$(perl -ne 'print if $,;$, = />consensus/' zikv_R${y}.out | sed -e 's/_//g')
            echo $consensus >> ../../targets/consensus_zikv.fa

            # Bracket dot structure
            echo ">R${y}" >> ../../targets/consensus_zikv.fold
            echo $consensus | RNAfold -p >> ../../targets/consensus_zikv.fold

            # Target scan format
            echo -n "R${y} 9606    " >> ../../targets/ts_zikv.txt
            echo $consensus >> ../../targets/ts_zikv.txt
            cd ..
        done
        #go back to data/
        cd ../../

}

    cd data/
    denv
    yfv
    zikv
    exit
