##############################################
#Gene prediction using BRAKER pipeline v2.1.2
##############################################

#RNA-seq data mapping to a genome sequence
sample=###
data=###
hisat2 -x index -1 ${data}/${sample}.Read1.trimmed.fq -2 ${data}/${sample}.Read2.trimmed.fq -p 12 -k 1 -S ${sample}.sam
samtools view -Sb ${sample}.sam > ${sample}.bam
samtools sort -@ 12 -o ${sample}.sort.bam ${sample}.bam


#Running BRAKER
braker.pl --genome=genome.fasta.masked \
 --bam=sample1.sort.bam,sample2.sort.bam,sample3.sort.bam \
 --species=species1 --cores=16 \
 --workingdir=out_braker --softmasking --UTR=on
 
#select genes with longest transcript
seqkit fx2tab -l augustus.hints_utr.codingseq |awk '{print$1"\t"$3}'|sort|perl filter-best_seq-length.pl > longest.gene.txt


