
#' Attempts to install a package from cyto repo
#'
#' This function is vectorised on `pkgs` so you can install multiple
#' packages in a single command.
#'
#' @inheritParams cyto_install_deps
#' @importFrom remotes install_remote
#' @export
#' @family package installation
#' @examples
#' \dontrun{
#' install_cyto("ggcyto")
#' }
install_cyto <- function(pkg, type = getOption("pkgType"),
                         dependencies = NA,
                         upgrade = c("default", "ask", "always", "never"),
                         force = FALSE,
                         quiet = FALSE,
                         build = TRUE, build_opts = c("--no-resave-data", "--no-manual", "--no-build-vignettes"),
                         build_manual = FALSE, build_vignettes = FALSE,
                         ...) {
  if(!isFALSE(dependencies))
  {
    pkgdir <- desc_to_local(pkg)
    on.exit({
      unlink(pkgdir, recursive = TRUE)
    })
    cyto_install_deps(pkgdir,
                      dependencies = dependencies,
                      upgrade = upgrade,
                      force = force,
                      quiet = quiet,
                      build = build,
                      build_opts = build_opts,
                      build_manual = build_manual,
                      build_vignettes = build_vignettes,
                      type = type,
                      ...)
  }
  remote <- cyto_remote(pkg, type = type)

  install_remote(remote,
                  dependencies = dependencies,
                  upgrade = upgrade,
                  force = force,
                  quiet = quiet,
                  build = build,
                  build_opts = build_opts,
                  build_manual = build_manual,
                  build_vignettes = build_vignettes,
                  repos = repos,
                  type = type,
                  ...)
}

#' construct a 'cyto_remote' object
#'
#' It queries the remote github repo and fetch the packager versions and download url
#' @inheritParams cyto_install_deps
#' @param ... arguments passed to [cyto_pkg_github_url]
#' @export
#' @examples
#' \dontrun{
#' cyto_remote("ggcyto")
#' }
cyto_remote <- function(pkg, type = getOption("pkgType"), ...) {
  owner = getOption("cyto_repo_owner")
  res <- cyto_pkg_github_url(pkg, owner, ...)
  res <- remotes:::remote("cran",
         name = pkg,
         repo = NULL,
         ver = res[["ver"]],
         url = res[["url"]],
         bioc_ver = res[["bioc_ver"]],
         pkg_type = type)
  class(res) <- c("cyto_remote", class(res))
  res
}

#' query cyto repo for the package version and its download url
#' @param pkgs the name of packages to query
#' @param ... arguments passed to [cyto_remote]
#' @export
#' @examples
#' \dontrun{
#' cyto_repo("ggcyto")
#' cyto_repo()#print all available cyto packages
#' cyto_repo(bioc_ver = "3.13")
#' }
cyto_repo <- function(pkgs = getOption("cyto_repos"), ...)
{
  do.call(rbind, lapply(pkgs, function(pkg){
                        as_tibble(cyto_remote(pkg, ...))
                      })
  )
}
#' @importFrom remotes remote_package_name
#' @export
remote_package_name.cyto_remote <- function(remote, ...) {
  remote$url
}
#' @importFrom remotes remote_sha
#' @export
remote_sha.cyto_remote <- function(remote, ...) {
  remote$ver

}

#' @export
format.cyto_remote <- function(x, ...) {
  "CYTO"
}

#' @importFrom tibble as_tibble
as_tibble.cyto_remote <- function(x, ...) {
  as_tibble(x[c("name", "ver", "url", "bioc_ver")])
}


#' get the download url of the package hosted as github release assets
#'
#' @param pkg the package name
#' @param owner the github owner
#' @param bioc_ver the corresponding bioconductor version
#' @importFrom gh gh
#' @importFrom remotes bioc_version
#' @examples
#' cyto_pkg_github_url("ggcyto")
cyto_pkg_github_url <- function(pkg, owner = getOption("cyto_repo_owner"), bioc_ver = bioc_version())
{
  releaseid <- gh("GET /repos/:owner/:repo/releases/tags/:tag", owner = owner, repo = pkg, tag = paste0("bioc_",bioc_ver))$id
  assets <- gh("GET /repos/:owner/:repo/releases/:release_id/assets", owner = owner, repo = pkg, release_id = releaseid)
  suffix <- switch(Sys.info()[['sysname']],
                   Linux = "tar\\.gz",
                   Darwin = "tgz",
                   Windows = "zip"
  )
  pkg_bin <- paste0("^", pkg, "_[0-9\\.]+\\.", suffix, "$")
  asset.names <- vapply(assets, "[[", "", "name")
  idx <- grepl(pkg_bin, asset.names)
  nfiles <- sum(idx)
  if(nfiles == 0)
    return(NA)
  else if(nfiles > 1)
  {
    return(NA)#todo: maybe get the latest version
  }else

    asset <- assets[[which(idx)]]

  ver <- sub(paste0("^", pkg, "_"), "", sub(paste0("\\.", suffix, "$"), "",  asset[["name"]]))
  list(ver = ver, url = asset[["browser_download_url"]], bioc_ver = bioc_ver)
}
