if (!requireNamespace("clusterProfiler", quietly = TRUE) || !requireNamespace("org.Hs.eg.db", quietly = TRUE)) {
  stop("Install clusterProfiler and org.Hs.eg.db before running enrichment.")
}
suppressPackageStartupMessages({library(clusterProfiler); library(org.Hs.eg.db)})

dir.create("results/05_GO_KEGG", recursive = TRUE, showWarnings = FALSE)
for (analysis in c("paper", "corrected")) {
  genes <- read.csv(file.path("results/04_common_DEGs", analysis, "common_directional_DEGs.csv"))$gene_symbol
  ids <- bitr(genes, fromType = "SYMBOL", toType = "ENTREZID", OrgDb = org.Hs.eg.db)
  for (ontology in c("BP", "CC", "MF")) {
    ans <- enrichGO(ids$ENTREZID, OrgDb = org.Hs.eg.db, keyType = "ENTREZID", ont = ontology,
                    pAdjustMethod = "BH", pvalueCutoff = 0.05, qvalueCutoff = 0.05)
    write.csv(as.data.frame(ans), file.path("results/05_GO_KEGG", paste0(analysis, "_GO_", ontology, ".csv")), row.names = FALSE)
  }
  kegg <- enrichKEGG(ids$ENTREZID, organism = "hsa", pAdjustMethod = "BH", pvalueCutoff = 0.05)
  write.csv(as.data.frame(kegg), file.path("results/05_GO_KEGG", paste0(analysis, "_KEGG.csv")), row.names = FALSE)
}
