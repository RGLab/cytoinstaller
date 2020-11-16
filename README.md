cytoinstaller
================
mike
11/15/2020

This package is a lightweight wrapper of some functions in
[`remotes`](https://github.com/r-lib/remotes). It installs the most
recent version of cyto packages from the common public repositories
e.g. Bioconductor, CRAN, as well as `CYTO` repository, which provides
the cyto packages built by github actions triggered by pushed commits.

## Installation

Install the released version of remotes from CRAN:

``` r
remotes::install_github("RGLab/cytoinstaller")
```

## Usage

To install the latest version of a cyto package (and also install or
update its dependencies.)

``` r
cytoinstaller::install_cyto("ggcyto")
```

To get the package info from `CYTO` repo,

``` r
cytoinstaller::cyto_repo("ggcyto")
```

To list all the package info,

``` r
cytoinstaller::cyto_repo()
```

## CYTO repo build status

<table class=" lightable-paper" style='font-family: "Arial Narrow", arial, helvetica, sans-serif; width: auto !important; margin-left: auto; margin-right: auto;'>

<thead>

<tr>

<th style="text-align:left;">

package

</th>

<th style="text-align:left;">

release

</th>

<th style="text-align:left;">

devel

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

<a href="https://github.com/RGLab/cytolib/actions"> cytolib </a>

</td>

<td style="text-align:left;">

<img src="https://github.com/RGLab/cytolib/workflows/build/badge.svg?branch=release">

</td>

<td style="text-align:left;">

<html>

<body>

<img src="https://github.com/RGLab/cytolib/workflows/build/badge.svg?branch=master">

</body>

</html>

</td>

</tr>

<tr>

<td style="text-align:left;">

<a href="https://github.com/RGLab/flowCore/actions"> flowCore </a>

</td>

<td style="text-align:left;">

<img src="https://github.com/RGLab/flowCore/workflows/build/badge.svg?branch=release">

</td>

<td style="text-align:left;">

<html>

<body>

<img src="https://github.com/RGLab/flowCore/workflows/build/badge.svg?branch=master">

</body>

</html>

</td>

</tr>

<tr>

<td style="text-align:left;">

<a href="https://github.com/RGLab/openCyto/actions"> openCyto </a>

</td>

<td style="text-align:left;">

<img src="https://github.com/RGLab/openCyto/workflows/build/badge.svg?branch=release">

</td>

<td style="text-align:left;">

<html>

<body>

<img src="https://github.com/RGLab/openCyto/workflows/build/badge.svg?branch=master">

</body>

</html>

</td>

</tr>

<tr>

<td style="text-align:left;">

<a href="https://github.com/RGLab/flowStats/actions"> flowStats </a>

</td>

<td style="text-align:left;">

<img src="https://github.com/RGLab/flowStats/workflows/build/badge.svg?branch=release">

</td>

<td style="text-align:left;">

<html>

<body>

<img src="https://github.com/RGLab/flowStats/workflows/build/badge.svg?branch=master">

</body>

</html>

</td>

</tr>

<tr>

<td style="text-align:left;">

<a href="https://github.com/RGLab/flowClust/actions"> flowClust </a>

</td>

<td style="text-align:left;">

<img src="https://github.com/RGLab/flowClust/workflows/build/badge.svg?branch=release">

</td>

<td style="text-align:left;">

<html>

<body>

<img src="https://github.com/RGLab/flowClust/workflows/build/badge.svg?branch=master">

</body>

</html>

</td>

</tr>

<tr>

<td style="text-align:left;">

<a href="https://github.com/RGLab/ggcyto/actions"> ggcyto </a>

</td>

<td style="text-align:left;">

<img src="https://github.com/RGLab/ggcyto/workflows/build/badge.svg?branch=release">

</td>

<td style="text-align:left;">

<html>

<body>

<img src="https://github.com/RGLab/ggcyto/workflows/build/badge.svg?branch=master">

</body>

</html>

</td>

</tr>

<tr>

<td style="text-align:left;">

<a href="https://github.com/RGLab/flowWorkspace/actions"> flowWorkspace
</a>

</td>

<td style="text-align:left;">

<img src="https://github.com/RGLab/flowWorkspace/workflows/build/badge.svg?branch=release">

</td>

<td style="text-align:left;">

<html>

<body>

<img src="https://github.com/RGLab/flowWorkspace/workflows/build/badge.svg?branch=master">

</body>

</html>

</td>

</tr>

<tr>

<td style="text-align:left;">

<a href="https://github.com/RGLab/CytoML/actions"> CytoML </a>

</td>

<td style="text-align:left;">

<img src="https://github.com/RGLab/CytoML/workflows/build/badge.svg?branch=release">

</td>

<td style="text-align:left;">

<html>

<body>

<img src="https://github.com/RGLab/CytoML/workflows/build/badge.svg?branch=master">

</body>

</html>

</td>

</tr>

<tr>

<td style="text-align:left;">

<a href="https://github.com/RGLab/ncdfFlow/actions"> ncdfFlow </a>

</td>

<td style="text-align:left;">

<img src="https://github.com/RGLab/ncdfFlow/workflows/build/badge.svg?branch=release">

</td>

<td style="text-align:left;">

<html>

<body>

<img src="https://github.com/RGLab/ncdfFlow/workflows/build/badge.svg?branch=master">

</body>

</html>

</td>

</tr>

<tr>

<td style="text-align:left;">

<a href="https://github.com/RGLab/cytoqc/actions"> cytoqc </a>

</td>

<td style="text-align:left;">

<img src="https://github.com/RGLab/cytoqc/workflows/build/badge.svg?branch=release">

</td>

<td style="text-align:left;">

<html>

<body>

<img src="https://github.com/RGLab/cytoqc/workflows/build/badge.svg?branch=master">

</body>

</html>

</td>

</tr>

<tr>

<td style="text-align:left;">

<a href="https://github.com/RGLab/COMPASS/actions"> COMPASS </a>

</td>

<td style="text-align:left;">

<img src="https://github.com/RGLab/COMPASS/workflows/build/badge.svg?branch=release">

</td>

<td style="text-align:left;">

<html>

<body>

<img src="https://github.com/RGLab/COMPASS/workflows/build/badge.svg?branch=master">

</body>

</html>

</td>

</tr>

</tbody>

</table>
