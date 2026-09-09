# Methodology map

| Stage | Input | Method | Output |
|---|---|---|---|
| Transcriptomics input | GSE65194, GSE45827, GSE36295 | GEO processed matrices and platform annotations | `data/transcriptomics`, `data/metadata` |
| Sample curation | GEO phenotypes | TNBC and normal breast only | `data/metadata/sample_metadata.tsv` |
| Quality control | Curated expression matrices | distributions, PCA | `results/01_QC` |
| Normalization audit | GEO processed values | scale inspection | `results/02_normalization` |
| Differential expression | Each accession separately | limma; BH < 0.05; abs(log2FC) > 2 | `results/03_DEG` |
| Paper consensus | Three DEG sets | direction-specific intersection | `results/04_common_DEGs/paper` |
| Corrected consensus | Independent accessions; duplicated cohort excluded | direction-specific intersection | `results/04_common_DEGs/corrected` |
| Functional analysis | Consensus genes | GO BP/CC/MF and KEGG | `results/05_GO_KEGG` |
| Metabolomics | Published 22 metabolites | reported FC, P and VIP; MSEA-ready export | `results/06_metabolomics` |
| Joint pathway | Consensus genes and metabolites | MetaboAnalyst Joint Pathway Analysis | `results/07_joint_pathway` |
| Network | Significant joint pathways | Cytoscape/Metscape | `results/08_network` |
| Validation | Six candidate genes | TCGA/GTEx, CPTAC, HPA, survival | `results/09_validation` |
