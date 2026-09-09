#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
Rscript scripts/01_prepare_transcriptomics.R
Rscript scripts/02_qc_and_deg.R
Rscript scripts/03_consensus.R
