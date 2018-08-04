#' Writes pkgdown if they don't already exist.
#' @param package_dir character. The directory of the package to write pkgdown for.
write_pkgdown <- function(package_dir) {
  check_for_pkgdown_package()
  devtools::document(package_dir)
  if (!inst_exists(package_dir)) { create_inst(package_dir) }
  if (!pkgdown_index_exists(package_dir)) { create_pkgdown_index(package_dir) }
  if (!pkgdown_folder_exists(package_dir)) { create_pkgdown_folder(package_dir) }
  pkgdown::build_site(package_dir)
}


#' Add pkgdown into the Rocco directory.
#'
#' Since Rocco and Pkgdown conflict for gh-pages and we often want both,
#' this will resolve the tension and create one harmonious site with rocco
#' docs located at index.html and pkgdown located at pkgdown/index.html.
#'
#' @param directory character. The directory Rocco is running in.
#' @param output character. The directory to create the skeleton in.
load_pkgdown <- function(directory, output) {
  create_pkgdown_directory <- function(dir) {
    unlink(dir, recursive = TRUE, force = TRUE)
    dir.create(dir, showWarnings = FALSE)
  }
  create_pkgdown_folder_tree <- function(dir, subdirs) {
    subdirs <- lapply(subdirs, function(subdir) file.path(dir, subdir))
    unlink(subdirs, recursive = TRUE, force = TRUE)
    lapply(subdirs, dir.create, showWarnings = FALSE)
  }
  determine_dir <- function(dir, file) {
    dir_split <- strsplit(file, "/")[[1]]
    if (length(dir_split) > 1) {
      file.path(dir, dir_split[[1]])
    } else { dir }
  }
  create_pkgdown_files <- function(files, source_dir, destination) {
    from_files <- lapply(files, function(file) file.path(source_dir, file))
    destination <- file.path(destination, "pkgdown")
    to_dirs <- Map(determine_dir, rep(destination, length(files)), files)
    Map(file.copy, from_files, to_dirs, overwrite = TRUE)
  }

  pkgdown_dir <- file.path(output, "pkgdown")
  create_pkgdown_directory(pkgdown_dir)
  web_dir <- file.path(directory, "inst", "web")

  pkgdown_subdirs <- grep(".html", dir(web_dir), value = TRUE,
    fixed = FALSE, invert = TRUE)
  create_pkgdown_folder_tree(pkgdown_dir, pkgdown_subdirs)

  pkgdown_files <- dir(web_dir, recursive = TRUE)
  create_pkgdown_files(pkgdown_files, source_dir = web_dir, destination = output)
}


#' Check to see if a directory exists within the package.
#' @param directory character. The directory of the package to check for pkgdown.
#' @param ... list. The folder structure to pass to \code{file.path}.
dir_exists <- function(directory, ...) {
  file.exists(file.path(directory, ...))
}

#' Create a directory if it doesn't exist.
#' @inheritParams dir_exists
dir_create <- function(directory, ...) {
  dir.create(file.path(directory, ...), showWarnings = FALSE)
}

#' Check whether the inst folder exists.
#' @inheritParams dir_exists
inst_exists <- function(directory) { dir_exists(directory, "inst") }

#' Create the inst directory.
#' @inheritParams dir_exists
create_inst <- function(directory) { dir_create(directory, "inst") }

#' Check whether the pkgdown folder exists.
#' @inheritParams dir_exists
pkgdown_folder_exists <- function(directory) {
  dir_exists(directory, "inst", "pkgdown")
}

#' Create the pkgdown directory.
#' @inheritParams dir_exists
create_pkgdown_folder <- function(directory) {
  dir_create(directory, "inst", "pkgdown")
}

#' Check whether a pkgdown index file exists.
#' @inheritParams dir_exists
pkgdown_index_exists <- function(directory) {
  pkgdown_folder_exists(directory) &&
   dir_exists(directory, "inst", "pkgdown", "index.r")
}

#' Create the pkgdown index.
#' @inheritParams dir_exists
create_pkgdown_index <- function(directory) {
  dir_create(directory, "inst", "pkgdown", "index.r")
}

#' Check whether pkgdown files have been written.
#' @inheritParams dir_exists
pkgdown_written <- function(directory) {
  dir_exists(directory, "inst", "web", "index.html")
}

#' Check whether pkgdown exist.
#' @inheritParams dir_exists
pkgdown_exist <- function(directory) {
  pkgdown_index_exists(directory) && pkgdown_written(directory)
}


#' Checks that the pkgdown package is installed.
check_for_pkgdown_package <- function() {
  if (!(is.element("pkgdown", utils::installed.packages()[, 1]))) {
    stop("You must install the pkgdown package to run pkgdown. ",
      "You can get it from https://github.com/hadley/pkgdown.", call. = FALSE)
  }
}
