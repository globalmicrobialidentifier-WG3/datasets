#!/bin/bash

NUMCPUS=2

set -e

THISDIR=$(dirname $0)

export PATH="$THISDIR/../scripts:$PATH"
# In case RAxML has to be downloaded, it will be here
export PATH="$PATH:$THISDIR/standard-RAxML-8.1.16"

# Print a message to stderr with the script name
function msg(){
  echo "$(basename $0): $@" >&2
}

msg "Looking for dependencies for both Gen-FS Gopher and for CFSAN SNP Pipeline"
for exe in esearch fastq-dump perl make GenFSGopher.pl; do
  echo "Testing PATH for $exe";
  which $exe || (echo "ERROR finding $exe;" exit 1;);
done
# Need perl >= 5.12.0
msg "Testing if perl >= 5.12.0 is in PATH"
perl -e 'use 5.12.0; print "  -OK\n"'

msg "Downloading datasets"

tsv="$THISDIR/lambda.tsv"
name=$(basename $tsv .tsv)

msg "Downloading $name"
GenFSGopher.pl --outdir $THISDIR/$name --layout cfsan --numcpus $NUMCPUS $tsv 
find . -type f -name '*.fastq.gz' -size 0 -exec rm -v {} \;

exit;
R1=$(find . -type f -name '*.fastq.gz');
mashtree --numcpus $NUMCPUS > lambda.mashtree.dnd
