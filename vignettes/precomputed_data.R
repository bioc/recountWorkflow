library("recount")

## Normally, one can use rtracklayer::import() to access remote parts of BigWig
## files without having to download the complete files. However, as of
## 2024-05-20 this doesn't seem to be working well. So this is a workaround to
## issue https://github.com/lawremi/rtracklayer/issues/83
download_study("SRP045638", type = "mean")

## Define expressed regions for study SRP045638, only for chromosome 21
regions <- expressed_regions("SRP045638", "chr21",
    cutoff = 5L,
    maxClusterGap = 3000L,
    outdir = "SRP045638"
)

saveRDS(regions, file = here::here("vignettes", "regions_unfilt_2024-05-21.rds"))


## Normally, one can use rtracklayer::import() to access remote parts of BigWig
## files without having to download the complete files. However, as of
## 2024-05-20 this doesn't seem to be working well. So this is a workaround to
## issue https://github.com/lawremi/rtracklayer/issues/83
download_study("SRP045638", type = "samples")

## Compute coverage matrix for study SRP045638, only for chromosome 21
## Takes about 4 minutes
rse_er <- coverage_matrix("SRP045638", "chr21", regions,
    chunksize = 2000, verboseLoad = FALSE, scale = FALSE,
    outdir = "SRP045638"
)

saveRDS(rse_er, file = here::here("vignettes", "rse_er_raw_2024-05-21.rds"))


## Get the bp coverage data for the plots
library("derfinder")
regionCov <- getRegionCoverage(
    regions = regions_resized, files = bws,
    targetSize = 40 * 1e6 * 100,
    totalMapped = colData(rse_er_scaled)$auc,
    verbose = FALSE
)

saveRDS(regionCov, file = here::here("vignettes", "regionCov_2024-05-21.rds"))
