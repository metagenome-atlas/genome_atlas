import os
from snakemake.shell import shell
from snakemake.io import glob_wildcards
from multiprocessing.dummy import Pool

pool = Pool(snakemake.threads)


for dir in snakemake.params.dirs:
    if not os.path.exists(dir):
        os.makedirs(dir)

path= os.path.join(snakemake.input[0],"{genome}"+snakemake.params.fasta_extension)
all_genomes = glob_wildcards(path).genome


print(f"Call genes of {len(all_genomes)} gneomes in {snakemake.threads} threads.")

def callgenes(genome):

    fasta = path.format(genome=genome)

    if not os.path.exists(f"annotations/faa/{genome}.faa.gz"):

        shell("callgenes.sh in={fasta} outa=annotations/faa/{genome}.faa.gz"
              " out=annotations/gff/{genome}.gff.gz"
              " out16S=annotations/16S/{genome}.fasta"
              " stats=annotations/stats/{genome}.json json=t ow > /dev/null"
              )


pool.map(callgenes, all_genomes)
