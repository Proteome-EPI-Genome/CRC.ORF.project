## Extract nearby predicted ORFs

awk -F '[\t|]' '{id="NR_120509.1"; start=360; stop=548; if($1 == id && (($2 >= start && $2 <= stop) || ($2 <= start && $3 >= start))){print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6}}' blast.seqdump.CompleteSeq.ORF.v2.tsv
