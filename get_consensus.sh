#!/bin/bash

function denv {
    for x in {1..4}
    do
        #open denv/5utr directory
        cd denv${x}/5UTR/
        echo ">5UTR" >> ../../consensus_denv${x}.fa
        perl -ne 'print if $,;$, = />consensus/' denv${x}.out >> ../../consensus_denv${x}.fa

        # Target scan format
        echo -n "5UTR 9606  " >> ../../ts_denv${x}.txt
        perl -ne 'print if $,;$, = />consensus/' denv${x}.out >> ../../ts_denv${x}.txt

        #open denv/3utr directory
        cd ../3UTR/
        for y in {1..3}
        do
            # do it for each region
            cd R${y}/
            echo ">R${y}" >> ../../../consensus_denv${x}.fa
            perl -ne 'print if $,;$, = />consensus/' denv${x}_R${y}.out >> ../../../consensus_denv${x}.fa

            # Target scan format
            echo -n "R${y} 9606    " >> ../../../ts_denv${x}.txt
            perl -ne 'print if $,;$, = />consensus/' denv${x}_R${y}.out >> ../../../ts_denv${x}.txt

            cd ..
        done
        #go back to data/
        cd ../../
    done
}

function yfv {
        #open denv/5utr directory
        cd YFV/5UTR/
        echo ">5UTR" >> ../../consensus_yfv.fa
        perl -ne 'print if $,;$, = />consensus/' yfv.out >> ../../consensus_yfv.fa

         # Target scan format
        echo -n "R${y} 9606    " >> ../../ts_yfv.txt
        perl -ne 'print if $,;$, = />consensus/' yfv.out >> ../../ts_yfv.txt

        #open denv/3utr directory
        cd ../3UTR
        for y in {1..3}
        do
            # do it for each region
            cd R${y}/
            echo ">R${y}" >> ../../../consensus_yfv.fa
            perl -ne 'print if $,;$, = />consensus/' yfv_R${y}.out >> ../../../consensus_yfv.fa

            # Target scan format
            echo -n "R${y} 9606    " >> ../../../ts_yfv.txt
            perl -ne 'print if $,;$, = />consensus/' yfv_R${y}.out >> ../../../ts_yfv.txt
            cd ..
        done
        #go back to data/
        cd ../../
}


function zikv {
            #open denv/5utr directory
        cd ZIKV/5UTR/
        echo ">5UTR" >> ../../consensus_zikv.fa
        perl -ne 'print if $,;$, = />consensus/' zikv.out >> ../../consensus_zikv.fa


        # Target scan format
        echo -n "R${y} 9606    " >> ../../ts_zikv.txt
        perl -ne 'print if $,;$, = />consensus/' zikv.out >> ../../ts_zikv.txt

        #open denv/3utr directory
        cd ../3UTR
        for y in {1..3}
        do
            # do it for each region
            cd R${y}/
            echo ">R${y}" >> ../../../consensus_zikv.fa
            perl -ne 'print if $,;$, = />consensus/' zikv_R${y}.out >> ../../../consensus_zikv.fa

            # Target scan format
            echo -n "R${y} 9606    " >> ../../../ts_zikv.txt
            perl -ne 'print if $,;$, = />consensus/' zikv_R${y}.out >> ../../../ts_zikv.txt
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
