#' Find all dependencies of a cyto package.
#'
#' Find all the dependencies of a package and determine whether they are ahead
#' or behind CRAN, bioc and CYTO repos.
#'
#' @param pkdir path to a package directory , or to a package tarball
#' @param ... arguments passed to [remotes::dev_package_deps()]
#' @importFrom remotes dev_package_deps
#' @export
#' @examples
#' \dontrun{
#' cyto_pkg_deps("../ggcyto/")
#' }
cyto_pkg_deps <- function(pkdir = ".", bioc_ver = bioc_version(), ...)
{
  bioc_ver <- normalize_bioc_ver(bioc_ver)

  #get deps from public repos (cran, bioc)
  ###################

  ## use envir to tell dev_package_deps to pick right bioc_ver
  ## since it currently doesn't take bioc_ver argument
  old.v <- Sys.getenv("R_BIOC_VERSION", "")
  Sys.setenv(R_BIOC_VERSION = as.character(bioc_ver))

  deps <- dev_package_deps(pkdir, ...)

  Sys.setenv(R_BIOC_VERSION = old.v)#restore old v


  #update it with github release version (when it is higher version)
  cyto_repos <- getOption("cyto_repos")
  for(i in seq_len(nrow(deps)))
  {
    package <- deps[i, ][["package"]]
    if(package %in% cyto_repos)
    {
      # browser()
      remote <- deps[i, ][["remote"]][[1]]

      #compare the public remote with cytorepo
      remote_new <- cyto_remote(package, bioc_ver = bioc_ver) #fetch pkg info from cyto remote repo
      if(!is.null(remote_new))
      {
        ver <- remote_sha(remote_new)
        diff1 <- remotes:::compare_versions(remote_sha(remote), ver, is_cran = TRUE)
        #replace the public remote by cyto remote when it is behind
        if(diff1 %in% c(remotes:::BEHIND, remotes:::UNINSTALLED))
        {
          deps[i, "available"] = ver
          deps[i, "is_cran"] = FALSE
          deps[i, ][["remote"]][[1]] = remote_new
        }
        #update diff
        deps[i, "diff"] = remotes:::compare_versions(deps[i, "installed"], ver, is_cran = TRUE)

      }
    }

  }
  deps
}


normalize_bioc_ver <- function(ver){
  if(tolower(ver) == "release")
    BIOC_RELEASE
  else if(tolower(ver) == "devel")
    BIOC_DEV
  else
    ver
}
#' Download DESCRIPTION file of the pkg from cyto repo
#' @param pkg package name.
desc_to_local <- function(pkg, bioc_ver = bioc_version(), ...){
  bioc_ver <- normalize_bioc_ver(bioc_ver)
  #download DESC file
  pkdir <- tempfile()
  dir.create(pkdir)
  if(bioc_ver == BIOC_DEV)
    branch <- "master"
  else
    branch <- "release"
  owner = getOption("cyto_repo_owner")
  url <- file.path("https://raw.githubusercontent.com", owner, pkg, branch, "DESCRIPTION")
  download.file(url, file.path(pkdir, "DESCRIPTION"), quiet = TRUE)
  return(pkdir)
}

#' Install package dependencies if needed.
#'
#' @inheritParams cyto_pkg_deps
#'
#' @param ... additional arguments passed to [utils::install.packages()].
#' @param build If `TRUE` build the package before installing.
#' @param build_opts Options to pass to `R CMD build`, only used when `build`
#' @param build_manual If `FALSE`, don't build PDF manual ('--no-manual').
#' @param build_vignettes If `FALSE`, don't build package vignettes ('--no-build-vignettes').
#' is `TRUE
#' @export
#' @examples
#' \dontrun{
#' cyto_install_deps("../ggcyto")
#' }
cyto_install_deps <- function(pkgdir = ".", dependencies = NA,
                         repos = getOption("repos"),
                         type = getOption("pkgType"),
                         upgrade = c("default", "ask", "always", "never"),
                         quiet = FALSE,
                         build = TRUE,
                         build_opts = c("--no-resave-data", "--no-manual", "--no-build-vignettes"),
                         build_manual = FALSE, build_vignettes = FALSE
                         , bioc_ver = bioc_version(), ...) {
  bioc_ver <- normalize_bioc_ver(bioc_ver)

  packages <- cyto_pkg_deps(
    pkgdir,
    repos = repos,
    dependencies = dependencies,
    type = type,
    bioc_ver = bioc_ver
  )

  dep_deps <- if (isTRUE(dependencies)) NA else dependencies

  update(
    packages,
    dependencies = dep_deps,
    quiet = quiet,
    upgrade = upgrade,
    build = build,
    build_opts = build_opts,
    build_manual = build_manual,
    build_vignettes = build_vignettes,
    type = type,
    repos = repos,
    ...
  )
}
