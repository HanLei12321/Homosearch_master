#!/usr/bin/perl -w
use strict;

my %hash1;

open IN,$ARGV[0];
while(my $line=<IN>){
chomp($line);
my @a=split/\s+/,$line;
$hash1{$a[0]}=$a[1];
}
close IN;

my %hash2;
open IN1,$ARGV[1];
while(my $line1=<IN1>){
chomp($line1);
my @b=split/\s+/,$line1;
$hash2{$b[0]}=$b[1];
}
close IN1;

open IN2,$ARGV[2];
while(my $line2=<IN2>){
chomp($line2);
my @c=split/\s+/,$line2;
if(exists $hash1{$c[0]}){
print "$c[0]\t$hash1{$c[0]}\t$c[1]\t$hash2{$c[1]}\n";
}
}
close IN2;

