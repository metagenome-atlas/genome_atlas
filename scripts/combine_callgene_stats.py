import os
import pandas as pd
from glob import glob
from multiprocessing.pool import Pool
import json


stats_files= glob('stats/*.json')


def read_callgenes_stats(json_file):

    name= os.path.splitext( os.path.basename(json_file))[0]
    with open(json_file) as jin:
        j= json.load(jin)

    d= pd.DataFrame(j).T.stack()
    d.name=name

    return d



pool= Pool(8)
results=pool.map(read_callgenes_stats,stats_files)


D= pd.concat(results,axis=1)

D.T.to_csv('Combined_stats.tsv',sep='\t')
