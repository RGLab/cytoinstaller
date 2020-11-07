options("cyto_repo_owner" = "mikejiang")
options("cyto_repos" = c("ggcyto", "flowWorkspace"))
#' @param pkg the package name
#' @param owner the github owner
#' @param ... arguments passed to remotes::dev_package_deps
#' @importFrom remotes dev_package_deps
#' @export
#' @examples
#' cyto_pkg_deps("ggcyto")
cyto_pkg_deps <- function(pkg, owner = getOption("cyto_repo_owner"), ...)
{
  #download DESC file
  pkdir <- tempfile()
  dir.create(pkdir)
  bioc_ver = bioc_version()
  branch <- paste0("bioc_", bioc_ver)
  url <- file.path("https://raw.githubusercontent.com", owner, pkg, branch, "DESCRIPTION")
  download.file(url, file.path(pkdir, "DESCRIPTION"), quiet = TRUE)
  #get deps from public repos (cran, bioc)
  deps <- dev_package_deps(pkdir, ...)
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
      remote_new <- cyto_remote(package) #fetch pkg info from cyto remote repo
      ver <- remote_sha(remote_new)
      diff1 <- remotes:::compare_versions(remote_sha(remote), ver, is_cran = TRUE)
      #replace the public remote by cyto remote when it is behind
      if(diff1 %in% c(remotes:::BEHIND, remotes:::UNINSTALLED))
      {
        deps[i, "available"] = ver
        deps[i, "diff"] = diff1
        deps[i, "is_cran"] = FALSE
        deps[i, ][["remote"]][[1]] = remote_new
      }
    }

  }
  deps
}


#' @export
#' @examples
#' \dontrun{
#' cyto_install_deps("ggcyto")
#' }
cyto_install_deps <- function(pkg = ".", dependencies = NA,
                         repos = getOption("repos"),
                         type = getOption("pkgType"),
                         upgrade = c("default", "ask", "always", "never"),
                         quiet = FALSE,
                         build = TRUE,
                         build_opts = c("--no-resave-data", "--no-manual", "--no-build-vignettes"),
                         build_manual = FALSE, build_vignettes = FALSE,
                         ...) {
  packages <- cyto_pkg_deps(
    pkg,
    repos = repos,
    dependencies = dependencies,
    type = type
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
