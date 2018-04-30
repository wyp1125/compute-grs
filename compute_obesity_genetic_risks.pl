if($#ARGV<0)
{
    print "Please supply a VCF file\n";
    exit;
}
open(input,"snp_reference.txt") || die "Could not find the 'snp_reference.txt' file!\n";
%aff={};
%inc={};
while($line=<input>)
{
    chomp($line);
    if($line ne "")
    {
        @a=split(" ",$line);
        $aff{$a[0]}=$a[2];
        $inc{$a[0]}=$a[4];
    }
}
open(input,"$ARGV[0]") || die "Could not find the input VCF file!\n";
$n=0;
while($line=<input>)
{
    if($line=~/^#/)
    {
        if($line=~/^#CHROM/)
        {
            chomp($line);
            @s=split("\t",$line);
            print "BMI-associated-SNP\tType";
            for($i=9;$i<=$#s;$i++)
            {
                print "\t",$s[$i];
                $sc[$i-9]=0;
            }
            print "\n";
        }
        next;
    }
    chomp($line);
    if($line ne "")
    {
        @a=split("\t",$line);
        if(exists $aff{$a[2]})
        {
            $nt[0]=$a[3];
            $nt[1]=$a[4];
            print $a[2],"\t";
            if($inc{$a[2]}==0)
            {
                print "Excluded";
            }
            else
            {
                print "Included";
                $n++;
            }
            for($i=9;$i<=$#a;$i++)
            {
                $gt[0]=substr($a[$i],0,1);
                $gt[1]=substr($a[$i],2,1);
                $locus_risk=0;
                for($j=0;$j<2;$j++)
                {   
                    if($gt[$j]=~/\d/)
                    {   
                        if($aff{$a[2]} eq $nt[$gt[$j]])
                        {
                            $locus_risk++;
                        }
                    }
                }
                print "\t",$locus_risk;
                if($inc{$a[2]}==1)
                {
                    $sc[$i-9]+=$locus_risk;
                }
            }
            print "\n";
        }
    }
}
if($n>0)
{
    print "Genetic risk score\tAveraged(Included only)";
    for($i=9;$i<=$#s;$i++)
    {
        printf("\t%4f",$sc[$i-9]/$n);
    }
    print "\n";
}
