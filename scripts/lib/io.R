read_geo_matrix <- function(path) {
  con <- gzfile(path, "rt")
  lines <- character()
  repeat {
    z <- readLines(con, n = 1L)
    if (!length(z) || grepl("^!series_matrix_table_begin", z)) break
    lines <- c(lines, z)
  }
  close(con)
  tab <- data.table::fread(cmd = paste("gzip -cd", shQuote(path), "| grep -v '^!'"),
                           fill = TRUE,
                           data.table = FALSE, check.names = FALSE)
  tab <- tab[!grepl("^!series_matrix_table_end", tab[[1L]]), , drop = FALSE]
  ids <- tab[[1L]]
  x <- as.matrix(tab[-1L])
  storage.mode(x) <- "double"
  rownames(x) <- ids

  field <- function(pattern, occurrence = 1L) {
    hit <- grep(pattern, lines)
    if (length(hit) < occurrence) return(rep(NA_character_, ncol(x)))
    z <- strsplit(lines[hit[occurrence]], "\t", fixed = TRUE)[[1L]][-1L]
    gsub('^"|"$', "", z)
  }
  chars <- grep("^!Sample_characteristics_ch1", lines, value = TRUE)
  meta <- data.frame(
    gsm = field("^!Sample_geo_accession"),
    title = field("^!Sample_title"),
    source = field("^!Sample_source_name_ch1"),
    stringsAsFactors = FALSE
  )
  for (z in chars) {
    values <- gsub('^"|"$', "", strsplit(z, "\t", fixed = TRUE)[[1L]][-1L])
    key <- trimws(sub(":.*$", "", values[which(nzchar(values))[1L]]))
    key <- make.names(tolower(key))
    meta[[key]] <- trimws(sub("^[^:]*:", "", values))
  }
  stopifnot(identical(meta$gsm, colnames(x)))
  list(expression = x, metadata = meta)
}

read_geo_annotation <- function(path) {
  command <- paste("gzip -cd", shQuote(path),
                   "| sed -n '/^!platform_table_begin$/,/^!platform_table_end$/p' | grep -v '^!'")
  data.table::fread(cmd = command, data.table = FALSE, check.names = FALSE)
}
