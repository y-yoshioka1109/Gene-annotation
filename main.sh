################
#Gene prediction
################

###########################################
Step 1 Gene prediction with BRAKER pipeline
###########################################

#RNA-seq data mapping to a genome sequence (hard-masked repeats)
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


#Select the longest transcript variants from each gene
seqkit fx2tab -l augustus.hints_utr.codingseq |awk '{print$1"\t"$3}'|sort|perl filter_seq-length.pl > longest.gene.txt
for i in `awk '{print$1}' longest.gene.txt`;do seqkit grep -p ${i} augustus.hints_utr.codingseq ;done > augustus.hints_utr.longest.codingseq
grep ">" augustus.hints_utr.longest.codingseq | perl -pe 's/>//g' > augustus.hints_utr.longest.lst
perl extract_codingseq.pl augustus.hints_utr.longest.lst augustus.hints_utr.gtf > augustus.hints_utr.longest.gtf

##################################################
Step 2 Gene prediction with transcriptome assembly
##################################################

#Genome-guided transcriptome assembly
stringtie -m 500 -p 8 -o ${sample}.bam.gtf ${sample}.bam
stringtie --merge -o merged.gtf sample1.sort.bam.gtf sample2.sort.bam.gtf sample3.sort.bam.gtf


#Get mRNA sequences
gffread merged.gtf -g genome.fasta.masked -w merged.fa

#Translation to amino acid sequences
TransDecoder.LongOrfs -m 100 -t merged.fa --output_dir merged.transdecoder

#convet from GTF to GFF3 for prediction using by TransDecoder
transdecoder/util/gtf_to_alignment_gff3.pl merged.gtf > merged.gff3

#Prediction by genome-based transcript structure
transdecoder/util/cdna_alignment_orf_to_genome_orf.pl \
 merged.transdecoder_def/longest_orfs.gff3 \
 merged.gff3 \
 merged.fa > merged.transdecoder.genome.gff3

#Get CDS sequences from each transcript
gffread merged.transdecoder.genome_def.gff3 -g genome.fasta.masked -x merged.transdecoder.genome.cds

#Select the longest transcripts from each gene
seqkit fx2tab -l merged.transdecoder.genome_def.cds |awk '{print$1"\t"$3}'|sort -k1 -nr|perl filter_seq-length.pl|awk '{print$1}' > longest.gene.txt
for i in `awk '{print$1}' longest.gene.txt`;do seqkit grep -p ${i} merged.transdecoder.genome.cds ;done > merged.transdecoder.genome.longest.cds
grep ">" merged.transdecoder.genome.longest.cds | perl -pe 's/>//g' > merged.transdecoder.genome.longest.lst
perl extract_longest2.pl merged.transdecoder.genome.longest.lst merged.transdecoder.genome_def.gff3 > merged.transdecoder.genome.longest.gff3
gffread merged.transdecoder.genome.longest.gff3 -g Mefflorescens_curated.fasta.masked -w merged.transdecoder.genome.longest.mrna


###########################################
Step 3 Integration step1 and step2
###########################################

#Prediction from AUGUSTUS hint file
#-> augustus.hints_utr.longest.codingseq, augustus.hints_utr.longest.gtf

#Prediction from StringTie
#-> merged.transdecoder.genome.longest.mrna, merged.transdecoder.genome.longest.gff3

#Prediction from AUGUSTUS ab initio
#-> augustus.ab_initio_utr.longest.codingseq, augustus.ab_initio_utr.longest.gtf

#Explore genes that are present in prediction from StringTie, but absent in prediction from AUGUSTUS hints
#Comparison of gene structures
gffcompare -r augustus.hints_utr.longest.gtf -o gffcomp merged.transdecoder.genome.longest.gtf 

#Extract genes that absent in prediction from AUGUSTUS hints
grep u gffcomp.tracking | awk -F"\t" '{print$5}' | awk -F"|" '{print$2}' > tmp.lst
for i in `cat tmp.lst`;do seqkit grep -p ${i} ;done > stringtie_add.fa 
grep ">" stringtie_add.fa | perl -pe 's/>//g' > stringtie_add.lst 

perl extract_codingseq2.pl stringtie_add.lst merged.transdecoder.genome.longest.gtf | perl -ne '@a=split(/\t/,$_);if($a[2] eq transcript){@b=split(/\"/,$a[8]);print"$a[0]\t$a[1]\tgene\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$a[7]\t$b[3]\n";print$_}else{print$_}' > stringtie_add.gtf

cat augustus.hints_utr.longest.gtf stringtie_add.gtf > tmp.gtf

#Explore genes that are present in prediction from AUGUSTUS ab initio, but absent in prediction from AUGUSTUS hints
#Comparison of gene structures
gffcompare -r tmp.gtf -o gffcomp2 augustus.ab_initio_utr.longest.gtf

#Extract genes that absent in prediction from AUGUSTUS hints
grep u gffcomp2.tracking | awk -F"\t" '{print$5}' | awk -F"|" '{print$2}' > tmp.lst
for i in `cat tmp.lst`;do seqkit grep -p ${i} ;done | perl -pe 's/>g/>gene/g' > abinitio_add.fa
grep ">" abinitio_add.fa | perl -pe 's/>//g' > abinitio_add.lst

perl extract_codingseq3.pl abinitio_add.lst augustus.ab_initio_utr.longest.gtf > abinitio_add.gtf


cat augustus.hints_utr.longest.mrna stringtie_def_add.fa ab_add.fa > merged.fa
cat augustus.hints_utr.longest.gtf ab_add.gtf stringtie_def_add.gtf > merged.gtf


##############
Step 4 Sorting
##############

perl add_intron_for_transdecoder.pl merged.gtf > tmp.gtf
for i in `awk '{print$1}' tmp.gtf | sort -n | uniq`;do  grep ${i} tmp.gtf | awk -F"\t" '$3=="gene"{print}' | sort -k 5 -n | perl name-lst.pl >> gene.lst ;done
perl change-name.pl gene.lst test.gtf > species1.gtf
gffread species1.gtf -g genome.fasta.masked -w species1.longest.mrna

GTF file = species1.gtf
The longest transcripts from each gene model = species1.longest.mrna

