
#' Attempts to install a package from cyto repo
#'
#' @param pkg The cyto package name, when not supplied, it tries to update all cyto packages
#' @inheritParams cyto_install_deps
#' @importFrom remotes install_remote
#' @export
#' @family package installation
#' @examples
#' \dontrun{
#' install_cyto("ggcyto")
#' install_cyto()#install/update all cyto packages
#' }
install_cyto <- function(pkg = NULL, type = getOption("pkgType"),
                         dependencies = NA,
                         upgrade = c("default", "ask", "always", "never"),
                         force = FALSE,
                         quiet = FALSE,
                         build = TRUE, build_opts = c("--no-resave-data", "--no-manual", "--no-build-vignettes"),
                         build_manual = FALSE, build_vignettes = FALSE,
                         ...) {
  if(is.null(pkg))
  {
  #create dummy pkg dcf to include all cyto packages as deps
    dcf <- read.dcf(file = system.file("DESCRIPTION", package = "cytoinstaller"))
    dcf[1, ][["Imports"]] <- paste(getOption("cyto_repos"), collapse = ",\n")
    pkgdir <- tempfile()
    dir.create(pkgdir)
    write.dcf(dcf, file = file.path(pkgdir, "DESCRIPTION"))
  }else
  {
    pkgdir <- desc_to_local(pkg, ...)
  }
  on.exit({
    unlink(pkgdir, recursive = TRUE)
  })
  if(!isFALSE(dependencies))
  {

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

  if(!is.null(pkg))
  {

    remote <- cyto_remote(pkg, type = type, ...)

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
  if(!is.null(res))
  {

    res <- remotes:::remote("cran",
           name = pkg,
           repo = NULL,
           ver = res[["ver"]],
           url = res[["url"]],
           bioc_ver = res[["bioc_ver"]],
           pkg_type = type)
    class(res) <- c("cyto_remote", class(res))

  }
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
#' \dontrun{
#' cyto_pkg_github_url("ggcyto")
#' }
cyto_pkg_github_url <- function(pkg, owner = getOption("cyto_repo_owner"), bioc_ver = bioc_version())
{
  bioc_ver <- normalize_bioc_ver(bioc_ver)
  releaseid <- try(gh("GET /repos/:owner/:repo/releases/tags/:tag"
                      , owner = owner, repo = pkg, tag = paste0("bioc_",bioc_ver)
                      )$id
                   , silent = TRUE)
  if(is(releaseid, "try-error"))
 {
     if(grepl("404 Not Found", releaseid))
       return(NULL)
    else
      stop(releaseid)
  }
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
    return(NULL)
  else
  {
    #get latest ver
    vers <- sapply(asset.names[idx], get_ver_from_asset_name, pkg = pkg, suffix = suffix)
    idx.max <- which(vers == max(vers))
    if(length(idx.max) > 1)
      stop("duplicated max versions!")
    asset <- assets[idx][[idx.max]]
    ver <- vers[idx.max]
  }
  list(ver = ver, url = asset[["browser_download_url"]], bioc_ver = bioc_ver)
}

get_ver_from_asset_name <- function(name, pkg, suffix){
  sub(paste0("^", pkg, "_"), "", sub(paste0("\\.", suffix, "$"), "",  name))
}
