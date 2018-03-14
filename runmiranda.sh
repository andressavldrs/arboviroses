#!/bin/bash
#
#  Runs miranda, structure_position and count_occurences to  all dengue virus
#  sorotypes. Reads from 3UTR and 5UTR, writes in targets/miranda/
readonly QUERY="mature_primates.fa"
readonly PARAMS="-quiet -strict -sc 150 -en -7"

cd data/
for d in */; do
  if [ -d "$d" ]; then
    # Now is not necessary do this YFV and ZIKV
    if [[ -d "$d" && $d != "ZIKV/" && $d != "YFV/" ]]; then
     
      # For 5'UTR region
      dir="$(basename "$d")"
      m_out="${dir}/targets/miranda/miranda_5UTR.out"
      r_out="${dir}/targets/miranda/refold_5UTR.out"
      targets="${dir}/targets/miranda"

      miranda $QUERY ${dir}/5UTR/${dir}_norep.fasta $PARAMS -out ${m_out}      
      # refold the individual sequences after RNAalifold - script from ViennaRNA      
      perl ../refold.pl  ${dir}/5UTR/${dir}.aln ${dir}/5UTR/alidot.ps > ${r_out}
      # select all targets by structure and classify possible candidates 
      perl ../structure_position.pl ${r_out} ${m_out} > ${targets}/str_5UTR.out
      # count possible candidates and all occurrences 
      perl ../count_occurences.pl < ${targets}/str_5UTR.out > ${targets}/mirna_5UTR.txt

      # For each region of 3'UTR (R1, R2, R3)
      for x in {1..3}; do
        
        m_out="${dir}/targets/miranda/miranda_R${x}.out"
        r_out="${dir}/targets/miranda/refold_R${x}.out"
        reg="${dir}_R${x}"
        r="R${x}"

        miranda $QUERY ${dir}/3UTR/${r}/${reg}_norep.fasta $PARAMS -out ${m_out}      
        perl ../refold.pl  ${dir}/3UTR/${r}/${reg}.aln ${dir}/3UTR/${r}/alidot.ps > ${r_out} 
        perl ../structure_position.pl ${r_out} ${m_out} > ${targets}/str_${r}.out 
        perl ../count_occurences.pl < ${targets}/str_${r}.out > ${targets}/mirna_${r}.txt
        
      done
    fi
  fi
done