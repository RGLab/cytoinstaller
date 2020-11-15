.onLoad <- function(libname, pkgname){
  options("cyto_repo_owner" = "RGLab")
  options("cyto_repos" = c("cytolib",  "flowCore", "openCyto", "flowStats", "flowClust", "ggcyto", "flowWorkspace"
                           , "CytoML", "ncdfFlow", "cytoqc", "COMPASS"))

}
