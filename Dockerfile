# Inheritance from bioconductor docker
FROM bioconductor/bioconductor_docker:devel

LABEL name="bioconductor/bioconductor_docker_basics" \
      version="0.0.1" \
      url="https://github.com/VallejosGroup/bioconductor_docker_basics" \
      maintainer="catalina.vallejos@igmm.ed.ac.uk" \
      description="Docker containing all requirements to run BASiCS Workflow" \
      license="Artistic-2.0"
      
# Update apt-get
# Follows Bioc suggestion, required to compile Rmarkdown into pdf
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
    apt-utils \
  	texlive \
  	texlive-latex-extra \
  	texlive-fonts-extra \
  	texlive-bibtex-extra \
  	texlive-science \
  	texi2html \
  	texinfo \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Trying to fix rmarkdown issue	
RUN touch /home/rstudio/.Rprofile

RUN Rscript -e 'install.packages(c( \
  "bit64", \
  "coda", \
  "data.table", \
  "knitr", \
  "ggplot2", \
  "ggpointdensity", \
  "pheatmap", \
  "rmarkdown", \
  "RSQLite", \
  "reshape2", \
  "hexbin", \
  "survival"), Ncpus = 4)'


RUN Rscript -e 'BiocManager::install(c( \
  "AnnotationDbi", \
  "BASiCS", \
  "BiocStyle", \
  "BiocWorkflowTools", \
  "biomaRt", \
  "EnsDb.Mmusculus.v79", \
  "GenomicFeatures", \
  "goseq", \
  "org.Mm.eg.db", \
  "scran", \
  "scater", \
  "SingleCellExperiment", \
  "BiocWorkflowTools"), Ncpus = 4)'

COPY Workflow.Rmd /home/rstudio/
COPY Workflow.bib /home/rstudio/
COPY Makefile /home/rstudio/
ADD figure /home/rstudio/figure/
COPY .here /home/rstudio/
COPY mycode.Rproj /home/rstudio/
