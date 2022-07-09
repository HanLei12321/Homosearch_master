# step 2 :  blast
ln -s ../0.input/hap1.cds
ln -s ../0.input/hap2.cds
ln -s ../0.input/hap1.gff
ln -s ../0.input/hap2.gff

$PYTHON_PATH -m jcvi.formats.gff bed \
--type=mRNA --key=Parent hap1.gff \
>hap1.bed
$PYTHON_PATH -m jcvi.formats.gff bed \
--type=mRNA --key=Parent hap2.gff \
>hap2.bed

cat hap1.bed \
|  awk '{print $4"\t"$1"\t"$2"\t"$3}'\
 >hap1_sort.bed
cat hap2.bed \
| awk '{print $4"\t"$1"\t"$2"\t"$3}' \
>hap2_sort.bed

mkdir db
$MAKEBLASTDB_PATH \
-in hap1.cds \
-out db/hap1 \
-dbtype nucl
$BLASTN_PATH -num_threads 5 \
-query hap2.cds \
-db db/hap1 \
-outfmt 6 \
-evalue 1e-5 \
-num_alignments 5 \
>hap1_hap2.blast

$PYTHON_PATH \
-m jcvi.compara.blastfilter \
--no_strip_names hap1_hap2.blast \
--sbed hap1.bed \
--qbed hap2.bed

cat hap1_hap2.blast.filtered \
| awk '{print $2"\t"$1}' \
>hap1_hap2_paired.lst
echo "#!/usr/bin/perl -w
use strict;

=head1  Name

        01.get_position.pl  --get postion and gene hash sites.
=head1 Description

        This program is mainly used to remove the gap of mapping sequences,so that we can use another program to find the true locations of the single bases.
=head1 example

        perl 01.remove.pl in.txt
=head1 Information

        Author:         Ruobing Han           @163.com
        Version:        1.0
        Data:           2022-04-13
        Update:         2022-4-13_v1      (First version)

=cut



my %hash1;
my %hash2;

open IN1,\$ARGV[0];
while(my \$line1=<IN1>){
chomp(\$line1);
#my @a=split/\s+/,\$line1;
my(\$ID1,\$GENE1)=(split /\s+/,\$line1,2)[0,1];
\$hash1{\$ID1}=\$GENE1;
}
close IN1;

open IN2,\$ARGV[1];
while(my \$line2=<IN2>){
chomp(\$line2);
#my @b=split/\s+/,\$line2;
my(\$ID2,\$GENE2)=(split /\s+/,\$line2,2)[0,1];
\$hash2{\$ID2}=\$GENE2;
}
close IN2;

#open IN, \$ARGV[2];
open IN3,\$ARGV[2];
while(my \$line3=<IN3>){
chomp(\$line3);
my @c=split/\s+/,\$line3;
#if((exists \$hash1{\$c[0]})and(exists \$hash2{\$c[1]})){
if(exists \$hash1{\$c[0]}){
        if(exists \$hash2{\$c[1]}){
        print \"\$c[0]\\t\$hash1{\$c[0]}\\t\$c[1]\t\$hash2{\$c[1]}\n\";}
        else{next;};
#print \"\$c[0]\\t\$hash1{\$c[0]}\\t\$c[1]\\t\$hash2{\$c[1]}\n\";
}
}
close IN3;
" >./get_position.pl

perl get_position.pl \
hap1_sort.bed \
hap2_sort.bed \
hap1_hap2_paired.lst \
|perl -pe 's/\./\t/g'\
| awk '$2==$7' \
>hap1_hap2_paired_position.final.txt

cat hap1_hap2.blast.filtered \
| awk '{print $2"\t"$1"\t"$3}' \
>hap1_hap2_identity_paired.lst

