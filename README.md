# TNBC multi-omics reanalysis

Reanalysis of Gong et al. (2024), *Comprehensive analysis of the metabolomics and transcriptomics uncovers the dysregulated network and potential biomarkers of Triple Negative Breast Cancer* (PMCID: PMC11552364; DOI: 10.1186/s12967-024-05843-y).

## Main finding

The study combined serum metabolomics and breast-tissue transcriptomics. Joint pathway analysis highlighted three pathways:

1. Tyrosine metabolism
2. Phenylalanine metabolism
3. Glycolysis/gluconeogenesis

| Type | Key integrated components |
|---|---|
| Metabolites | 4-hydroxyphenylacetaldehyde; oxaloacetic acid (oxalacetic acid in Table 1) |
| Genes | MAOA; ADH1B; ADH1C; AOC3; TAT; PCK1 |

These are the paper's reported integration results. They connect altered amino-acid and glucose metabolism with TNBC.

## Pipeline architecture

```text
                                  TNBC MULTI-OMICS STUDY
                                             |
                     +-----------------------+-----------------------+
                     |                                               |
              METABOLOMICS                                   TRANSCRIPTOMICS
                     |                                               |
       TNBC and healthy serum                       GSE65194 + GSE45827 + GSE36295
          discovery: 18 + 21                                   TNBC vs normal
          validation: 7 + 5                                           |
                     |                                      sample curation and QC
                  UHPLC-MS                                  normalization assessment
                     |                                               |
          MSConvert -> XCMS                                   limma DEG analysis
                     |                                  adjusted P < 0.05, |log2FC| > 2
          PCA -> OPLS-DA -> VIP                                       |
                     |                                      direction-specific overlap
             22 metabolites                                   common TNBC DEGs
                     |                                               |
       ROC analysis and validation                           GO and KEGG enrichment
                     |                                               |
       7-methylguanine biomarker                                     |
                     +-----------------------+-----------------------+
                                             |
                               MetaboAnalyst Joint Pathway
                                             |
                    tyrosine metabolism + phenylalanine metabolism
                              + glycolysis/gluconeogenesis
                                             |
                                  Cytoscape/Metscape network
                                             |
                    4-hydroxyphenylacetaldehyde + oxaloacetic acid
                                             +
                         MAOA + ADH1B + ADH1C + AOC3 + TAT + PCK1
                                             |
                       GEPIA + UALCAN/CPTAC + HPA + western blot
                                             |
                                  Kaplan-Meier survival analysis
```

## How the biomarkers were obtained

### 1. Metabolomics discovery

Serum from 18 TNBC patients and 21 healthy controls was analysed by UHPLC-MS in positive and negative ion modes. The paper converted raw files to mzXML with MSConvert and processed them with XCMS. PCA assessed variation and OPLS-DA modelled group separation.

Differential metabolites were selected using:

- VIP > 1
- Mann-Whitney P < 0.05
- fold change >= 1.5 or <= 0.67

This produced 22 differential metabolites: 13 increased and 9 decreased in TNBC. Their published values are in `data/metabolomics/published_22_metabolites.csv`.

### 2. Diagnostic metabolite evaluation

Seven metabolites showed reported diagnostic ability:

- 7-methylguanine
- Pipecolic acid
- L-methionine
- Oxoglutaric acid
- Bilirubin
- Thymidine
- 4-hydroxyphenylacetaldehyde

7-methylguanine was the strongest reported diagnostic biomarker. In the discovery cohort, its AUC was 0.992, sensitivity was 100%, specificity was 95.2%, and Youden index was 0.952. In the 7-TNBC/5-control validation set, its reported AUC was 0.971.

### 3. Transcriptomics analysis

| Dataset | Platform | Samples retained | Reanalysis DEGs |
|---|---|---:|---:|
| GSE65194 | GPL570 | 55 TNBC, 11 normal | 2,783 |
| GSE45827 | GPL570 | 41 TNBC, 11 normal | 2,867 |
| GSE36295 | GPL6244 | 11 TNBC, 5 normal | 222 |

Each dataset was analysed separately with limma. Probes were mapped to gene symbols, duplicate symbols were resolved using the most significant probe, and genes were retained at adjusted P < 0.05 and absolute log2 fold change > 2.

The three-dataset directional intersection produced 158 genes: 61 upregulated and 97 downregulated. The paper reported 160 genes: 57 upregulated and 103 downregulated. The difference reflects current GEO annotation, probe mapping and gene-level deduplication.

GSE65194 contains technical replicate arrays, while GSE45827 represents the same Institut Curie biological cohort. Therefore:

- `paper` uses all three accessions to approximate the publication.
- `corrected` excludes GSE45827 and produces 162 consensus genes.

### 4. Multi-omics integration

The paper submitted the 22 differential metabolites and 160 common DEGs to MetaboAnalyst Joint Pathway Analysis.

| Pathway | Interpretation | Reported integrated components |
|---|---|---|
| Tyrosine metabolism | Altered aromatic amino-acid degradation | 4-hydroxyphenylacetaldehyde with MAOA, ADH1B, ADH1C, AOC3 and TAT-associated components |
| Phenylalanine metabolism | Altered phenylalanine-to-tyrosine connections | 4-hydroxyphenylacetaldehyde with MAOA, AOC3 and TAT-associated components |
| Glycolysis/gluconeogenesis | Altered glucose and energy metabolism | Oxaloacetic acid with PCK1 and connected alcohol-dehydrogenase components |

These descriptions summarize pathway membership and network associations; they do not establish causal interactions.

### 5. Network and validation

Cytoscape with Metscape connected the pathway metabolites and genes. The principal components were 4-hydroxyphenylacetaldehyde, oxaloacetic acid, MAOA, ADH1B, ADH1C, AOC3, TAT and PCK1.

The study evaluated the six genes using GEPIA for RNA expression, UALCAN/CPTAC for protein expression, the Human Protein Atlas for immunohistochemistry, western blotting in cell lines and Kaplan-Meier survival analysis. AOC3 and PCK1 were reported to be associated with overall survival.

## Results status

| Folder | Status | Contents or requirement |
|---|---|---|
| `results/01_QC` | Complete | PCA and expression-distribution plots |
| `results/02_normalization` | Complete | Curated expression matrices and metadata |
| `results/03_DEG` | Complete | DEG tables, volcano plots and heatmaps |
| `results/04_common_DEGs` | Complete | Paper-style and corrected intersections |
| `results/05_GO_KEGG` | Pending | Requires clusterProfiler and org.Hs.eg.db |
| `results/06_metabolomics` | Published results recorded | Raw LC-MS data and sample intensities were not deposited |
| `results/07_joint_pathway` | Published results recorded | Exact MetaboAnalyst statistics require the original export |
| `results/08_network` | Published results recorded | Integrated components are listed |
| `results/09_validation` | Published targets recorded | Independent database validation remains to be run |

Empty directories represent stages not independently executed. They are not evidence of completed analysis.

## Run the completed analysis

```bash
Rscript scripts/01_prepare_transcriptomics.R
Rscript scripts/02_qc_and_deg.R
Rscript scripts/03_consensus.R
```

After installing `clusterProfiler` and `org.Hs.eg.db`:

```bash
Rscript scripts/04_enrichment.R
```

## Project structure

```text
TNBC_multiomics_reanalysis/
├── config/                      analysis thresholds
├── data/
│   ├── metadata/                sample metadata and platform annotations
│   ├── metabolomics/            published 22-metabolite table
│   └── transcriptomics/         GEO expression matrices
├── docs/                        methodology map and data audit
├── logs/                        execution logs
├── results/
│   ├── 01_QC/
│   ├── 02_normalization/
│   ├── 03_DEG/
│   ├── 04_common_DEGs/
│   ├── 05_GO_KEGG/
│   ├── 06_metabolomics/
│   ├── 07_joint_pathway/
│   ├── 08_network/
│   └── 09_validation/
└── scripts/                     executable workflow
```

## Reproducibility limitation

The transcriptomics branch is reproducible from GEO. The metabolomics discovery and ROC analyses cannot be recalculated because the raw LC-MS files and sample-level peak-intensity matrix were not deposited. The 22 metabolites, diagnostic statistics and three joint pathways are therefore labelled as published results rather than newly computed results.
