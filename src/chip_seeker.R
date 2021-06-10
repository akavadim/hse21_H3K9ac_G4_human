source('lib.R')

###

 if (!requireNamespace("BiocManager", quietly = TRUE))
   install.packages("BiocManager")
 #BiocManager::install("TxDb.Hsapiens.UCSC.hg19.knownGene")
 #BiocManager::install("ChIPseeker")
 #BiocManager::install("clusterProfiler")
 #BiocManager::install("org.Hs.eg.db")
 #BiocManager::install("TxDb.Mmusculus.UCSC.mm10.knownGene")

library(ChIPseeker)
library(TxDb.Hsapiens.UCSC.hg19.knownGene)
#library(TxDb.Mmusculus.UCSC.mm10.knownGene)
library(clusterProfiler)

###

#NAME <- 'H3K9ac_K562_ENCFF280OVN_hg19.filtered'
#NAME <- 'H3K9ac_K562_ENCFF568DJI_hg19.filtered'
NAME <- 'G4_seq_Li_K.merge'
BED_FN <- paste0(DATA_DIR, NAME, '.bed')

###

txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene

peakAnno <- annotatePeak(BED_FN, tssRegion=c(-3000, 3000), TxDb=txdb, annoDb="org.Hs.eg.db")

png(paste0(OUT_DIR, 'chip_seeker.', NAME, '.plotAnnoPie.png'))
plotAnnoPie(peakAnno)
dev.off()