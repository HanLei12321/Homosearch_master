mkdir 2.statistics
cd 2.statistics

ln -s ../1.blast/hap1.bed
ln -s ../1.blast/hap2.bed
ln -s ../1.blast/hap1_hap2_paired_position.final.txt
cat hap1.bed | awk '{print $1}' | sort | uniq > hap1_id.lst
cat hap2.bed | awk '{print $1}' | sort | uniq > hap2_id.lst
cat hap1.bed hap2.bed >hap1_hap2_merge.bed
echo "
setwd(\"./\")
library(dplyr)
library(stringr)
library(ggplot2)

df<-read.table(\"tmp1.txt\",header = F)
table(df\$V1)
freq1 <- table(df\$V1)
freq2<- table(df\$V2)
write.table(freq1,file=\"chr_HOM1gene_num.txt\",sep=\"\\t\",quote=F,row.names=F,col.names=F)
write.table(freq2,file=\"chr_HOM2gene_num.txt\",sep=\"\\t\",quote=F,row.names=F,col.names=F)

" >./get_genenum_freq.R

$R_PATH --no-restore --file=get_genenum_freq.R
cat hap1_hap2_paired_position.final.txt | awk '{print $2"."$3"\t"$7"."$8}' | sort | uniq >tmp1.txt
echo "#!/usr/bin/perl -w
use strict;

=head1  Name

        01.get_position.pl  --get postion and gene hash sites.
=head1 Description

        This program is mainly used to remove the gap of mapping sequences,so that we can use another program to find the true locations of the single bases.
=head1 example

        perl 01.remove.pl in.txt
=head1 Information

        Author:         Ruobing Han           471410707@qq.com
        Version:        1.0
        Data:           2022-04-13
        Update:         2022-4-13_v1      (First version)

=cut
my %hash1;

open IN,\$ARGV[0];
while(my \$line=<IN>){
chomp(\$line);
my @a=split/\\s+/,\$line;
\$hash1{\$a[0]}=\$a[1];
}
close IN;

my %hash2;
open IN1,\$ARGV[1];
while(my \$line1=<IN1>){
chomp(\$line1);
my @b=split/\\s+/,\$line1;
\$hash2{\$b[0]}=\$b[1];
}
close IN1;

open IN2,\$ARGV[2];
while(my \$line2=<IN2>){
chomp(\$line2);
my @c=split/\\s+/,\$line2;
if(exists \$hash1{\$c[0]}){
print \"\$c[0]\\t\$hash1{\$c[0]}\\t\$c[1]\\t\$hash2{\$c[1]}\\n\";
}
}
close IN2;

">./get_num.pl

echo "
setwd(\"./\")
library(dplyr)
library(stringr)
library(ggplot2)

df<-read.table(\"tmp1.txt\",header = F)

table(df\$V1)
freq1 <- table(df\$V1)
freq2<- table(df\$V2)

write.table(freq1,file=\"chr_HOM1gene_num.txt\",sep=\"\\t\",quote=F,row.names=F,col.names=F)

write.table(freq2,file=\"chr_HOM2gene_num.txt\",sep=\"\\t\",quote=F,row.names=F,col.names=F)

">./get_HOMgenenum_freq.R

$R_PATH --no-restore --file=./get_HOMgenenum_freq.R

perl get_num.pl chr_HOM1gene_num.txt chr_HOM2gene_num.txt tmp1.txt  >tmp2.txt
echo "#!/usr/bin/perl -w
use strict;

=head1  Name

        01.get_position.pl  --get postion and gene hash sites.
=head1 Description

        This program is mainly used to remove the gap of mapping sequences,so that we can use another program to find the true locations of the single bases.
=head1 example

        perl 01.remove.pl in.txt
=head1 Information

        Author:         Ruobing Han           471410707@qq.com
        Version:        1.0
        Data:           2022-04-13
        Update:         2022-4-13_v1      (First version)

=cut
my %hash1;

open IN,\$ARGV[0];
while(my \$line=<IN>){
chomp(\$line);
my @a=split/\\s+/,\$line;
\$hash1{\$a[0]}=\$a[1];
}
close IN;

open IN2,\$ARGV[1];
while(my \$line2=<IN2>){
chomp(\$line2);
my @c=split/\\s+/,\$line2;
if(exists \$hash1{\$c[0]}){
print \"\$c[0]\\t\$hash1{\$c[0]}\\t\$c[1]\\t\$c[2]\\t\$hash1{\$c[2]}\\t\$c[3]\\n\";
}
}
close IN2;

">./get_cov.pl

perl get_cov.pl chr_gene_num.txt tmp2.txt | awk '{print $1"\t"$2"\t"$3"\t"$3/$2*100"\t"$4"\t"$5"\t"$6"\t"$6/$5*100}' >table1.txt
echo -e "Chromosome_Hap1\tTotal_gene_num_Hap1\tHomologous_gene_num_Hap1\tratio_Hap1\tChromosome_Hap2\tTotal_gene_num_Hap2\tHomologous_gene_num_Hap2\tratio_Hap2" >table1_title.txt
cat table1_title.txt table1.txt >table1_final.txt
echo "
library(patchwork)
library(ggplot2)

data<-read.table(\"table1_final.txt\",sep=\"\t\",header=T)
data<-as.data.frame(data)
data<-aaa
head(aaa)
ggplot(data,aes(Chromosome_Hap1,Homologous_gene_num_Hap1))+
  geom_bar(stat=\"identity\",aes(fill=data\$Chromosome_Hap1))+
  labs(x='chromosome',y='allele gene number')+
  ggtitle(\"Distribution of allele gene in hap1\")+
  labs(y=\"Allele gene number\",x=\"chromosome\")+
  theme(plot.title = element_text(hjust = 0.5,size = 15,face = \"bold\"),
        axis.text = element_text(size = 12,
                                 face = \"plain\"),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12))+
  guides(fill=F)

p1<-ggplot(data,aes(Chromosome_Hap1,Homologous_gene_num_Hap1))+
  geom_bar(stat=\"identity\",
           aes(fill=data\$Chromosome_Hap1))+
  labs(x='chromosome',
       y='allele gene number')+
  ggtitle(\"Distribution of allele gene in hap1\")+
  labs(y=\"Allele gene number\",x=\"chromosome\")+
  theme(plot.title = element_text(hjust = 0.5,size = 15,face = \"bold\"),
        axis.text = element_text(size = 12,
                                 face = \"plain\"),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12))+
  guides(fill=F)

p2<-ggplot(data,aes(Chromosome_Hap2,Homologous_gene_num_Hap2))+
  geom_bar(stat=\"identity\",
           aes(fill=data\$Chromosome_Hap2))+
  labs(x='chromosome',
       y='allele gene number')+
  ggtitle(\"Distribution of allele gene in hap2\")+
  labs(y=\"Allele gene number\",x=\"chromosome\")+
  theme(plot.title = element_text(hjust = 0.5,size = 15,face = \"bold\"),
        axis.text = element_text(size = 12,
                                 face = \"plain\"),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12))+
  guides(fill=F)

p3<- p1+p2+plot_layout(ncol=1)

p3

ggsave(p3,filename=\"Distribution_of_allele_gene_number_hap1_hap2.pdf\",width =10,height = 5.7)


">./plot1.R

$R_PATH --no-restore --file=plot1.R


cd ../
mkdir 3.output
cd 3.output/
cp ../2.statistics/Distribution_of_allele_gene_number_hap1_hap2.pdf .
cp ../2.statistics/table1_final.txt .
cp ../2.statistics/hap1_hap2_paired_position.final.txt .

