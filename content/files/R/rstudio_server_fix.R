#!/usr/bin/env Rscript

set_r_environment <- function() {
  env_path <- file.path(
    normalizePath("/opt/texlive/2018/bin/x86_64-linux"),
    normalizePath("/usr/local/sbin"),
    normalizePath("/usr/local/bin"),
    normalizePath("/usr/sbin"),
    normalizePath("/usr/bin"),
    fsep = .Platform$path.sep
  )
  env_r_libs_site <- normalizePath("/usr/lib64/R/library")

  renviron_file_path <- file.path(
    normalizePath(Sys.getenv("HOME")),
    ".Renviron"
  )
  renviron_file <- file(description = renviron_file_path)
  renviron <- readLines(con = renviron_file)
  subset_renviron <- !mapply(
    FUN = grepl,
    x = renviron,
    MoreArgs = list(pattern = "(PATH|R_LIBS_SITE)")
  )
  patch_renviron <- sort(
    c(
      renviron[subset_renviron],
      paste("PATH", env_path, sep = "="),
      paste("R_LIBS_SITE", env_r_libs_site, sep = "=")
    )
  )
  writeLines(
    text = patch_renviron,
    con = renviron_file
  )
  close(renviron_file)
}

set_r_environment()
rm(set_r_environment)
