#!/bin/sh
#=============================================================#
#  script for launching beagle 4.0 for phasing and imputation #
#=============================================================#

# set number of chromosomes and parameters
nb_chromosomes=3
convert_genotypes_to_impute_to_vcf=true
phase_reference_genotypes=false
impute_genotypes=true

# convert genotypes to impute by chromosome to vcf
if [ "$convert_genotypes_to_impute_to_vcf"=true ] ; then
        for chr in $(seq 1 1 $nb_chromosomes)
        do
                java -jar programs/beagle2vcf.jar \
                chrom=$chr \                                                 	# chromosome number
                markers=data/data_to_impute/markers_format_chr$chr.txt \     	# the genotypes with the Beagle format
                bgl=data/data_to_impute/genotypes_format_chr$chr.txt \       	# the markers with the Beagle format
                missing=NA \                                                 	# the code for missing data in your files
                out=data/data_to_impute/genotypes_to_impute_chr$chr.vcf      	# the output name
        done
fi

# phase reference genotypes if necessary
if [ "$phase_reference_genotypes"=true ] ; then
        for chr in $(seq 1 1 $nb_chromosomes)
        do
		java -Xmx2g -jar programs/beagle.r1399.jar \			# max 2Gb of memory allowed for the phasing
		gt=data/reference_data/reference_genotypes_chr$chr.vcf \
		ped=data/shared_data/pedigree_data.txt \
		out=data/reference_data/phased_reference_chr$chr &		# The & at the end allows to run the phasing
										# for the nb_chromosomes simultaneously
        done
fi

# impute genotypes in data_to_impute folder, results will be redirected to imputed_data folder
if [ "$impute_genotypes"=true ] ; then
        for chr in $(seq 1 1 $nb_chromosomes)
        do
		java -Xmx32g -jar programs/beagle.r1399.jar \
		ref=data/reference_data/phased_reference_chr$chr.vcf \
		gt=data/data_to_impute/genotypes_to_impute_chr$chr.vcf \
		ped=data/shared_data/pedigree_data.txt \			# only if there are duos/trios in your data to impute
		out=data/imputed_data/imputed_results_chr$chr &
        done
fi
