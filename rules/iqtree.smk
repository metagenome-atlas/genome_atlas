import os



rule iqtree:
    input:
        lambda wildcards: msa_paths[wildcards.msa]
    output:
        "iQTree/{msa}.treefile"
    threads:
        config['threads']
    resources:
        mem=config['large_mem'],
    params:
        prefix = lambda wc, output: os.path.splitext(output[0])[0],
        extra='-fast'
    log:
        "tree/iqtree_{msa}.log"
    conda:
        '../envs/iqtree.yaml'
    benchmark:
        "logs/benchmarks/iqtree/{msa}.tsv"
    shell:
        "iqtree -s {input[0]} "
        "-pre {params.prefix} "
        "{params.extra} "
        "-mem {resources.mem}G -nt {threads} "
