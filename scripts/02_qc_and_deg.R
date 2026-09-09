suppressPackageStartupMessages({library(limma); library(ggplot2); library(pheatmap)})

dir.create("results/01_QC", recursive = TRUE, showWarnings = FALSE)
dir.create("results/03_DEG", recursive = TRUE, showWarnings = FALSE)

platforms <- c(GSE65194 = "GPL570", GSE45827 = "GPL570", GSE36295 = "GPL6244")

for (gse in names(platforms)) {
  obj <- readRDS(file.path("results/02_normalization", paste0(gse, "_curated.rds")))
  x <- obj$expression
  m <- obj$metadata
  if (quantile(x, 0.99, na.rm = TRUE) > 100) x <- log2(x + 1)

  pdf(file.path("results/01_QC", paste0(gse, "_boxplot.pdf")), width = 10, height = 5)
  boxplot(x, outline = FALSE, las = 2, cex.axis = 0.45, ylab = "Expression")
  dev.off()

  pca <- prcomp(t(x), scale. = FALSE)
  pv <- summary(pca)$importance[2, 1:2] * 100
  p <- ggplot(data.frame(PC1 = pca$x[, 1], PC2 = pca$x[, 2], group = m$group),
              aes(PC1, PC2, color = group)) + geom_point(size = 2) + theme_classic() +
    labs(x = sprintf("PC1 (%.1f%%)", pv[1]), y = sprintf("PC2 (%.1f%%)", pv[2]), color = NULL)
  ggsave(file.path("results/01_QC", paste0(gse, "_PCA.pdf")), p, width = 6, height = 5)

  group <- factor(m$group, levels = c("Normal", "TNBC"))
  design <- model.matrix(~0 + group)
  colnames(design) <- levels(group)
  fit <- eBayes(contrasts.fit(lmFit(x, design), makeContrasts(TNBC - Normal, levels = design)))
  tab <- topTable(fit, number = Inf, sort.by = "P")
  tab$probe_id <- rownames(tab)

  ann <- readRDS(file.path("data/metadata", paste0(platforms[[gse]], "_annotation.rds")))
  id_col <- grep("^ID$|^ID_REF$", names(ann), value = TRUE)[1L]
  symbol_col <- grep("gene.symbol", names(ann), ignore.case = TRUE, value = TRUE)[1L]
  map <- ann[, c(id_col, symbol_col)]
  names(map) <- c("probe_id", "gene_symbol")
  tab <- merge(tab, map, by = "probe_id", all.x = TRUE, sort = FALSE)
  tab$gene_symbol <- sub(" ?///.*$", "", tab$gene_symbol)
  tab <- tab[nzchar(tab$gene_symbol) & !is.na(tab$gene_symbol), ]
  tab <- tab[order(tab$adj.P.Val, -abs(tab$logFC)), ]
  tab <- tab[!duplicated(tab$gene_symbol), ]
  tab$direction <- ifelse(tab$logFC > 0, "up", "down")
  tab$significant <- tab$adj.P.Val < 0.05 & abs(tab$logFC) > 2
  write.csv(tab, file.path("results/03_DEG", paste0(gse, "_DEG.csv")), row.names = FALSE)

  vp <- ggplot(tab, aes(logFC, -log10(P.Value), color = significant)) +
    geom_point(size = 0.6, alpha = 0.6) + scale_color_manual(values = c("grey75", "#B2182B")) +
    geom_vline(xintercept = c(-2, 2), linetype = 2) + geom_hline(yintercept = -log10(0.05), linetype = 2) +
    theme_classic() + labs(x = "log2 fold change", y = "-log10 P", color = NULL)
  ggsave(file.path("results/03_DEG", paste0(gse, "_volcano.pdf")), vp, width = 6, height = 5)

  top <- head(tab$probe_id[tab$significant], 50)
  if (length(top) > 1) {
    z <- t(scale(t(x[top, , drop = FALSE])))
    pheatmap(z, annotation_col = data.frame(group = group, row.names = colnames(z)),
             show_colnames = FALSE, filename = file.path("results/03_DEG", paste0(gse, "_heatmap.pdf")))
  }
}
