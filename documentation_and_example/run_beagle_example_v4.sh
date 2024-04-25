#!/bin/bash
if [ ! -f beagle.r1399.jar ]; then
  echo
  echo "Downloading beagle.r1399.jar"
  wget http://faculty.washington.edu/browning/beagle/beagle.r1399.jar
fi

echo
echo "*** Downloading some 1000 Genomes Project data to file: test.r1399.vcf.gz ***"
echo
wget http://faculty.washington.edu/browning/beagle/test.r1399.vcf.gz

echo
echo "*** Creating test files: ref.r1399.vcf.gz target.r1399.vcf.gz ***"
echo
zcat test.r1399.vcf.gz | cut -f1-190 | tr '/' '|' | gzip > ref.r1399.vcf.gz
zcat test.r1399.vcf.gz | cut -f1-9,191-200 | gzip > target.r1399.vcf.gz


echo
echo "*** Running test analysis with \"gt=\" argument ***"
echo
java -jar beagle.r1399.jar gt=test.r1399.vcf.gz out=out.gt

echo
echo "*** Running test analysis with \"gl=\" argument ***"
echo
java -jar beagle.r1399.jar gl=test.r1399.vcf.gz out=out.gl

echo
echo "*** Running test analysis with \"ref=\" argument ***"
echo
java -jar beagle.r1399.jar ref=ref.r1399.vcf.gz gt=target.r1399.vcf.gz out=out.ref
