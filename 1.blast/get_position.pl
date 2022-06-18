#!/usr/bin/perl -w
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

open IN1,$ARGV[0];
while(my $line1=<IN1>){
chomp($line1);
#my @a=split/\s+/,$line1;
my($ID1,$GENE1)=(split /\s+/,$line1,2)[0,1];
$hash1{$ID1}=$GENE1;
}
close IN1;

open IN2,$ARGV[1];
while(my $line2=<IN2>){
chomp($line2);
#my @b=split/\s+/,$line2;
my($ID2,$GENE2)=(split /\s+/,$line2,2)[0,1];
$hash2{$ID2}=$GENE2;
}
close IN2;

#open IN, $ARGV[2];
open IN3,$ARGV[2];
while(my $line3=<IN3>){
chomp($line3);
my @c=split/\s+/,$line3;
#if((exists $hash1{$c[0]})and(exists $hash2{$c[1]})){
if(exists $hash1{$c[0]}){
	if(exists $hash2{$c[1]}){
	print "$c[0]\t$hash1{$c[0]}\t$c[1]\t$hash2{$c[1]}\n";}
	else{next;};
#print "$c[0]\t$hash1{$c[0]}\t$c[1]\t$hash2{$c[1]}\n";
}
}
close IN3;



