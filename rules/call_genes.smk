



rule call_genes:
    input:
        genome_dir
    output:
        faa=directory("annotations/faa"),
        ribo=directory("annotations/16S"),
        stats=directory("annotations/stats")
    params:
        extension=config['fasta_extension']
    benchmark:
        "logs/benchmark/callgenes.txt"
    resources:
        time=config["runtime"]["long"],
        mem=20
    threads:
        1
    run:

        try:
            from tqdm import tqdm
        except ImportError:
            def tqdm(*args):
                return tuple(*args)


        for dir in output:
            os.makedirs(dir)

        path= os.path.join(input[0],"{genome}"+config['fasta_extension'])

        all_genomes = glob_wildcards(path).genome

        for genome in tqdm(all_genomes):

            fasta = path.format(genome=genome)

            shell("callgenes.sh in={fasta} outa={output.faa}/{genome}.faa.gz"
                  " out16S={output.ribo}/{genome}.fasta"
                  " stats={output.stats}/{genome}.json json=t ow &> /dev/null"
                  )
