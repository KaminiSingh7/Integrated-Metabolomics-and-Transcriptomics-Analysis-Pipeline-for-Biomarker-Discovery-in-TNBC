# Integrated Metabolomics and Transcriptomics Analysis for Biomarker Discovery in Triple-Negative Breast Cancer (TNBC)

## Overview

This repository presents a reproducible multi-omics workflow integrating **LC-MS-based untargeted metabolomics** and **public transcriptomic datasets** to identify metabolic biomarkers, dysregulated pathways, and potential molecular mechanisms associated with **Triple-Negative Breast Cancer (TNBC)**.

The workflow combines differential metabolite analysis with differential gene expression analysis, followed by pathway enrichment and metabolite–gene integration to uncover biologically relevant metabolic alterations.

---

## Study Workflow

```
Clinical Samples
      │
      ▼
Untargeted LC-MS Metabolomics
      │
      ▼
Data Preprocessing & Quality Control
      │
      ▼
Differential Metabolite Analysis
      │
      ▼
Candidate Biomarker Identification
      │
      ├───────────────────────────────┐
      │                               │
      ▼                               ▼
ROC Analysis                  Pathway Enrichment

Public GEO Transcriptomic Datasets
                │
                ▼
      Differential Expression Analysis
                │
                ▼
      Differentially Expressed Genes
                │
                ▼
      Multi-Omics Integration
                │
                ▼
 Metabolite–Gene Pathway Mapping
                │
                ▼
 Identification of Key Genes &
 Differential Metabolites
                │
                ▼
 Biological Interpretation
```

---

## Objectives

- Identify significantly altered serum metabolites in TNBC.
- Discover potential diagnostic biomarkers using ROC analysis.
- Identify differentially expressed genes (DEGs) from GEO transcriptomic datasets.
- Integrate metabolomics and transcriptomics data.
- Reveal dysregulated metabolic pathways associated with TNBC.
- Identify key metabolite–gene interactions contributing to disease progression.

---

## Methodology

### 1. Metabolomics Analysis

- Sample Collection
  - TNBC patients (n = 18)
  - Healthy Controls (n = 21)

- Untargeted LC-MS analysis

- Data preprocessing

- Statistical analysis
  - Normalization
  - Differential metabolite analysis
  - Fold Change
  - Statistical significance testing

- Biomarker evaluation
  - ROC Curve Analysis

---

### 2. Transcriptomics Analysis

- Download public TNBC datasets from GEO

- Gene expression preprocessing

- Differential expression analysis

- Identification of significant DEGs

---

### 3. Multi-Omics Integration

Integrated analysis was performed using significant metabolites and DEGs through pathway-based mapping.

The integration identified common dysregulated metabolic pathways and highlighted biologically important metabolite–gene relationships.

---

## Key Findings

### Differential Metabolites

- 22 significant metabolites identified.

### Potential Diagnostic Biomarker

- 7-Methylguanine

### Significantly Enriched Pathways

- Tyrosine metabolism
- Phenylalanine metabolism
- Glycolysis / Gluconeogenesis

### Key Differential Metabolites

- 4-Hydroxyphenylacetaldehyde
- Oxaloacetic acid

### Key Differentially Expressed Genes

- MAOA
- ADH1B
- ADH1C
- AOC3
- TAT
- PCK1

---

## Repository Structure

```
├── data/
│   ├── metabolomics/
│   ├── transcriptomics/
│   └── processed/
│
├── scripts/
│   ├── preprocessing/
│   ├── differential_analysis/
│   ├── enrichment/
│   ├── integration/
│   └── visualization/
│
├── results/
│   ├── figures/
│   ├── tables/
│   ├── pathway_analysis/
│   └── biomarkers/
│
├── notebooks/
│
├── docs/
│
└── README.md
```

---

## Software and Tools

- R
- Bioconductor
- GEOquery
- limma
- clusterProfiler
- KEGG
- MetaboAnalyst
- ggplot2
- dplyr
- tidyverse

---

## Analysis Pipeline

✔ Data Collection

↓

✔ LC-MS Metabolomics Processing

↓

✔ Differential Metabolite Analysis

↓

✔ ROC-Based Biomarker Evaluation

↓

✔ GEO Transcriptomic Analysis

↓

✔ Differential Gene Expression Analysis

↓

✔ Multi-Omics Integration

↓

✔ Pathway Enrichment

↓

✔ Biological Interpretation

---

## Biological Significance

The integrated analysis demonstrates that metabolic dysregulation is a hallmark of TNBC.

The identified metabolite–gene interactions provide insights into altered energy metabolism and suggest potential biomarkers for diagnosis as well as candidate therapeutic targets.

---

## Reproducibility

This repository is designed to provide a transparent and reproducible workflow for:

- Untargeted metabolomics analysis
- Differential gene expression analysis
- Multi-omics data integration
- Biomarker discovery
- Functional pathway analysis

---

## Citation

If you use this workflow, please cite the original publication:

> Integrated metabolomics and transcriptomics analysis identifies metabolic biomarkers and dysregulated pathways in Triple-Negative Breast Cancer (TNBC).

---

## License

This project is intended for academic and research purposes.

---

## Contact

For questions, suggestions, or collaborations, please open an Issue or submit a Pull Request.

---

### Keywords

Triple-Negative Breast Cancer • TNBC • Multi-Omics • Metabolomics • Transcriptomics • LC-MS • Differential Gene Expression • Biomarkers • KEGG • Pathway Enrichment • Bioinformatics • Systems Biology
