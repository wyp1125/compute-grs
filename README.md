# compute-grs
A small Perl script for computing genetic risk scores for obesity from a VCF file.

27 BMI-associated SNPs are searched. However, only 11 SNPs are most effective and used to compute the genetic risk score for obesity based on our recent research.

Note: the 'SNP_reference.txt' file should be placed within the same folder of the perl script.

Usage: perl compute_obesity_genetic_risks.pl VCF_file.
