


rule call_genes_genome:
    input:
        os.path.join(genome_dir,"{genome}"+config['fasta_extension'])
    output:
        faa="annotations/faa/{genome}.faa.gz",
        gff="annotations/gff/{genome}.gff.gz",
        ribo="annotations/16S/{genome}.fasta",
        stats="annotations/stats/{genome}.json"
    resources:
        time=1,
        mem=2
    threads:
        1
    shell:
        "callgenes.sh in={fasta} outa={output.faa}"
        " out={output.gff}"
        " out16S={output.ribo}"
        " stats={output.stats} json=t ow &> /dev/null"


def call_genes_input(wildcards):

    genomes= glob_wildcards(os.path.join(genome_dir,"{genome}"+config['fasta_extension'])
                            ).genome

    return expand("annotations/faa/{genome}.faa.gz",genome=genomes)


rule call_genes:
    input:
        call_genes_input

# rule call_genes:
#     input:
#         genome_dir
#     output:
#         faa=directory("annotations/faa"),
#         gff=directory("annotations/gff"),
#         ribo=directory("annotations/16S"),
#         stats=directory("annotations/stats")
#     params:
#         extension=config['fasta_extension']
#     benchmark:
#         "logs/benchmark/callgenes.txt"
#     resources:
#         time=config["runtime"]["long"],
#         mem=20
#     threads:
#         1
#     run:
#
#         try:
#             from tqdm import tqdm
#         except ImportError:
#             def tqdm(*args):
#                 return tuple(*args)
#
#
#         for dir in output:
#             os.makedirs(dir)
#
#         path= os.path.join(input[0],"{genome}"+config['fasta_extension'])
#
#         all_genomes = glob_wildcards(path).genome
#
#         for genome in tqdm(all_genomes):
#
#             fasta = path.format(genome=genome)
#
#             shell("callgenes.sh in={fasta} outa={output.faa}/{genome}.faa.gz"
#                   " out={output.gff}/{genome}.gff.gz"
#                   " out16S={output.ribo}/{genome}.fasta"
#                   " stats={output.stats}/{genome}.json json=t ow &> /dev/null"
#                   )
