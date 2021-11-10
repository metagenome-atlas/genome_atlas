#
#
#
# rule call_genes_genome:
#     input:
#         os.path.join(genome_dir,"{genome}"+config['fasta_extension'])
#     output:
#         faa="annotations/faa/{genome}.faa.gz",
#         gff="annotations/gff/{genome}.gff.gz",
#         ribo="annotations/16S/{genome}.fasta",
#         stats="annotations/stats/{genome}.json"
#     resources:
#         time=1,
#         mem=2
#     threads:
#         1
#     shell:
#         "callgenes.sh in={fasta} outa={output.faa}"
#         " out={output.gff}"
#         " out16S={output.ribo}"
#         " stats={output.stats} json=t ow &> /dev/null"
#
#
# def call_genes_input(wildcards):
#
#     genomes= glob_wildcards(os.path.join(genome_dir,"{genome}"+config['fasta_extension'])
#                             ).genome
#
#     return expand("annotations/faa/{genome}.faa.gz",genome=genomes)
#
#
# rule call_genes:
#     input:
#         call_genes_input

rule call_genes:
    input:
        genome_dir
    output:
        touch("annotations/call_genes_finished")
    params:
        fasta_extension=config['fasta_extension'],
        dirs= ["annotations/faa","annotations/gff","annotations/16S","annotations/stats"]
    benchmark:
        "logs/benchmark/callgenes.txt"
    resources:
        time=config["runtime"]["long"],
        mem=20
    threads:
        10
    script:
        "../scripts/many_callgenes.py"


# import pandas as pd
# from glob import glob
# D= {}
#
# for j in glob('stats/*.json'):
#     ...:
#     ...:     name= os.path.splitext( os.path.basename(j))[0]
#     ...:     print(name)
#     ...:     try:
#     ...:
#     ...:         d= pd.read_json(j).stack()
#     ...:         D[name]=d
#     ...:     except ValueError:
#     ...:         pass
                # not all files have content
#
#
# D= pd.concat(D,axis=1).T
#
# D.to_csv('Combined_stats.tsv',sep='\t')
