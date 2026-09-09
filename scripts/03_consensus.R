dir.create("results/04_common_DEGs/paper", recursive = TRUE, showWarnings = FALSE)
dir.create("results/04_common_DEGs/corrected", recursive = TRUE, showWarnings = FALSE)

read_sig <- function(gse, direction) {
  x <- read.csv(file.path("results/03_DEG", paste0(gse, "_DEG.csv")), check.names = FALSE)
  unique(x$gene_symbol[x$significant & x$direction == direction])
}

write_consensus <- function(accessions, outdir) {
  up <- Reduce(intersect, lapply(accessions, read_sig, direction = "up"))
  down <- Reduce(intersect, lapply(accessions, read_sig, direction = "down"))
  ans <- rbind(data.frame(gene_symbol = sort(up), direction = "up"),
               data.frame(gene_symbol = sort(down), direction = "down"))
  write.csv(ans, file.path(outdir, "common_directional_DEGs.csv"), row.names = FALSE)
  writeLines(up, file.path(outdir, "common_up.txt"))
  writeLines(down, file.path(outdir, "common_down.txt"))
  data.frame(analysis = basename(outdir), up = length(up), down = length(down), total = nrow(ans))
}

summary <- rbind(
  write_consensus(c("GSE65194", "GSE45827", "GSE36295"), "results/04_common_DEGs/paper"),
  write_consensus(c("GSE65194", "GSE36295"), "results/04_common_DEGs/corrected")
)
write.csv(summary, "results/04_common_DEGs/summary.csv", row.names = FALSE)
