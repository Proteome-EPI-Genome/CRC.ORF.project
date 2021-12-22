#!/bin/sh
#Last-modified: 4:21 PM Friday, December 22, 2021

####################### Scripts Description ###############################################################################################################
#  
#  Gene expression quantification for Bulk RNA-seq
#  
#  @status:  personal use, not published
#  @version: 1.0
#  @author:  Yanjun WEI
#  @contact: jason.yj.wei@gmail.com, ywei4@mdanderson.org
#
###########################################################################################################################################################

### Initial Job Request ###################################################################################################################################
dir="RNAseq/HCT116/191210_CZ-ELFN1_PM1168/"
index="hg38/GRCh38.primary_assembly.genome"
annotation="hg38/gencode.v22.primary_assembly.annotation.gff3"

package="star_result_hg38"
CountOutFile="HCT116_191210_CZ-ELFN1_PM1168.gene_id.gff3.annotation.htseqcount.out"
###########################################################################################################################################################

module purge
module load bedtools/2.24.0
module load htseq

mkdir "$dir$package"
mkdir "$dir$package"/bam/
mkdir "$dir$package"/bigwig/
mkdir "$dir$package"/htseq-count/

bamfiles=""

for file in "$dir"fastq/*.fastq
do
    filename="${file##*/}"
    ~/Programs/STAR-2.6.1b/bin/Linux_x86_64/STAR --runThreadN 16 --genomeDir ~/star-index/"$index"/ --readFilesIn "$dir"fastq/"${filename%.*}".fastq --outFileNamePrefix "$dir$package"/bam/"${filename%.*}" --outSAMunmapped Within --outFilterType BySJout --twopassMode Basic --outSAMtype BAM SortedByCoordinate

    bedtools genomecov -bg -ibam "$dir$package"/bam/"${filename%.*}"Aligned.sortedByCoord.out.bam -split -scale 1.0 > "$dir$package"/bigwig/"${filename%.*}"Aligned.sortedByCoord.bedgraph && LC_COLLATE=C sort -k1,1 -k2,2n "$dir$package"/bigwig/"${filename%.*}"Aligned.sortedByCoord.bedgraph > "$dir$package"/bigwig/"${filename%.*}"Aligned.sorted.bedgraph && ~/Programs/ucscApps/bedGraphToBigWig "$dir$package"/bigwig/"${filename%.*}"Aligned.sorted.bedgraph ~/star-index/"$index"/chrNameLength.txt "$dir$package"/bigwig/"${filename%.*}"Aligned.sortedByCoord.bw && rm "$dir$package"/bigwig/"${filename%.*}"Aligned.sorted*.bedgraph

    if [[ "$bamfiles" == "" ]]
    then
        bamfiles="$dir$package"/bam/"${filename%.*}"Aligned.sortedByCoord.out.bam
    else
        bamfiles="$bamfiles"" ""$dir$package"/bam/"${filename%.*}"Aligned.sortedByCoord.out.bam
    fi
done

python -m HTSeq.scripts.count --stranded reverse --additional-attr gene_name gene_type -f bam $bamfiles ~/refgenomes/"$annotation" > "$dir$package"/htseq-count/"$CountOutFile".reverse
