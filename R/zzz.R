BIOC_RELEASE <- NULL
BIOC_DEV <- NULL

.onLoad <- function(libname, pkgname){
  options("cyto_repo_owner" = "RGLab")
  options("cyto_repos" = c("cytolib",  "flowCore", "openCyto", "flowStats", "flowClust", "ggcyto", "flowWorkspace"
                           , "CytoML", "ncdfFlow", "cytoqc", "COMPASS"))
  BIOC_RELEASE <<- remotes:::bioconductor$get_release_version()
  BIOC_DEV <<- remotes:::bioconductor$get_devel_version()
}
