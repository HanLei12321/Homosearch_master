set -e
echo "check profile ... "
source ./profile
mkdir 0.input
cd 0.input
cat $HAP1_GFF | perl -pe 's/ID=/Parent=/g' >hap1.gff
cat $HAP2_GFF | perl -pe 's/ID=/Parent=/g' >hap2.gff

 #gtf file can be get use this comand below.
$GRRREAD_PATH hap1.gff -T -o hap1.gtf
$GRRREAD_PATH hap2.gff -T -o hap2.gtf
echo "input files prepared ... "

