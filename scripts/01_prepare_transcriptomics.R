source("scripts/lib/io.R")

dir.create("data/metadata", recursive = TRUE, showWarnings = FALSE)
dir.create("results/02_normalization", recursive = TRUE, showWarnings = FALSE)

accessions <- c(GSE65194 = "GPL570", GSE45827 = "GPL570", GSE36295 = "GPL6244")
all_meta <- list()

for (gse in names(accessions)) {
  path <- file.path("data/transcriptomics", gse, paste0(gse, "_series_matrix.txt.gz"))
  obj <- read_geo_matrix(path)
  m <- obj$metadata
  m$dataset <- gse
  m$platform <- accessions[[gse]]
  m$group <- NA_character_

  if (gse == "GSE65194") {
    m$group[grepl("^TNBC", m$title, ignore.case = TRUE)] <- "TNBC"
    m$group[grepl("^(Normal|Healthy)", m$title, ignore.case = TRUE)] <- "Normal"
    m$subject_id <- sub(".*(TUM[0-9]+).*", "\\1", m$title)
    m$subject_id[which(m$group == "Normal")] <- sub(".*?(NORMAL[0-9]+).*", "\\1", toupper(m$title[which(m$group == "Normal")]))
  } else if (gse == "GSE45827") {
    m$group[grepl("^(Basal|TN)", m$title, ignore.case = TRUE) | grepl("Triple Negative", m$source, ignore.case = TRUE)] <- "TNBC"
    m$group[grepl("^(Normal|Healthy)", m$title, ignore.case = TRUE) | grepl("healthy|normal", m$source, ignore.case = TRUE)] <- "Normal"
    m$subject_id <- sub(".*Sample([0-9]+).*", "S\\1", m$title, ignore.case = TRUE)
  } else {
    tn_col <- grep("^triple.negative", names(m), value = TRUE)[1L]
    tissue_col <- grep("^tissue$", names(m), value = TRUE)[1L]
    m$group[m[[tn_col]] == "1"] <- "TNBC"
    m$group[grepl("normal", m[[tissue_col]], ignore.case = TRUE)] <- "Normal"
    m$subject_id <- m$gsm
  }

  keep <- !is.na(m$group)
  x <- obj$expression[, keep, drop = FALSE]
  m <- m[keep, , drop = FALSE]
  x <- x[, m$gsm, drop = FALSE]
  saveRDS(list(expression = x, metadata = m),
          file.path("results/02_normalization", paste0(gse, "_curated.rds")))
  all_meta[[gse]] <- m[, c("gsm", "dataset", "platform", "group", "subject_id", "title", "source")]
}

metadata <- do.call(rbind, all_meta)
metadata <- metadata[, c("gsm", "dataset", "platform", "group", "subject_id", "title", "source")]
write.table(metadata, "data/metadata/sample_metadata.tsv", sep = "\t", row.names = FALSE, quote = FALSE)

for (gpl in unique(accessions)) {
  a <- read_geo_annotation(file.path("data/metadata", paste0(gpl, ".annot.gz")))
  saveRDS(a, file.path("data/metadata", paste0(gpl, "_annotation.rds")))
}
