
# cytoinstaller

> Install cyto R Packages from remote repositories, 
> including GitHub release, CRAN, and Bioconductor


This package is a lightweight wrapper of some functions in [`remotes`](https://github.com/r-lib/remotes).
Besides all the common public repositories e.g. Bioconductor, CRAN, it also install from `CYTO` repository, which typically contains the latest version of cyto packages. 

## Installation

Install the released version of remotes from CRAN:

```r
remotes::install_github("RGLab/cytoinstaller")
```

## Usage

To install the latest version of a cyto package (and also install or update its dependencies.)

```r
cytoinstaller::install_cyto("ggcyto")
```

To get the package info from `CYTO` repo,

```r
cytoinstaller::cyto_repo("ggcyto")
```

To list all the package info,

```r
cytoinstaller::cyto_repo()
```
