#!/usr/bin/env Rscript

'SCEVAN single sample analysis.
Usage:
    script_run_SCEVAN.R [options] (<count_mtx>)
Options:
    -h --help            Show this screen.
    --sample=<s>             Sample name to save results optional.
    --par_cores=<p>      Number of cores to run the pipeline optional [default: 20]
    --norm_cells=<f>         Vector of normal cells in .rds format 
    --subclones          Boolean value TRUE if you are interested 
                         in analysing the clonal structure and FALSE 
                         if you are only interested in the classification 
                         of malignant and non-malignant cells.optional.
    --beta_vega=<b>         Specifies beta parameter for segmentation, higher beta 
                         for more coarse-grained segmentation. optional. [default: 0.5]
    --clonalCN           Get clonal CN profile inference from all tumour cells.
    --plotTree           Plot Phylogenetic tree.
    --organism=<o>      Organism to be analysed, "mouse" or "human" [default: human]
Arguments:
    count_mtx Raw count gene-by-cell matrix in .rds format.
' -> doc

library(docopt)
opts <- docopt(doc)
print(opts)

if (!file.exists(opts$count_mtx)) {
  stop(sprintf("%s does not exist.", opts$count_mtx))
}

count_mtx=opts$count_mtx
par_cores= as.integer(opts$par_cores)
norm_cells=opts$norm_cells
subclones=opts$subclones
beta_vega=as.numeric(opts$beta_vega)
clonalCN=opts$clonalCN
plotTree=opts$plotTree
organism=opts$organism
sample=opts$sample

suppressPackageStartupMessages({
  require(SCEVAN)
})

count_mtx=readRDS(count_mtx)
if(!is.null(norm_cells)) norm_cells=readRDS(norm_cells)
res=SCEVAN::pipelineCNA(count_mtx, sample = sample, par_cores = par_cores, 
    norm_cell=norm_cells,SUBCLONES = subclones, plotTree = plotTree, organism=organism)

saveRDS(res,sprintf("output/%s_result.rds", sample))

