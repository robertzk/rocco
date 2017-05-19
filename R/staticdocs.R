#' Writes staticdocs if they don't already exist.
#' @param package_dir character. The directory of the package to write staticdocs for.
write_staticdocs <- function(package_dir) {
  check_for_staticdocs_package()
  devtools::document(package_dir)
  if (!inst_exists(package_dir)) { create_inst(package_dir) }
  if (!staticdocs_index_exists(package_dir)) { create_staticdocs_index(package_dir) }
  if (!staticdocs_folder_exists(package_dir)) { create_staticdocs_folder(package_dir) }
  pkgdown::build_site(path = package_dir, preview = FALSE)
}


#' Add staticdocs into the Rocco directory.
#'
#' Since Rocco and Staticdocs conflict for gh-pages and we often want both,
#' this will resolve the tension and create one harmonious site with rocco
#' docs located at index.html and staticdocs located at staticdocs/index.html.
#'
#' @param directory character. The directory Rocco is running in.
#' @param output character. The directory to create the skeleton in.
load_staticdocs <- function(directory, output) {
  create_staticdoc_directory <- function(dir) {
    unlink(dir, recursive = TRUE, force = TRUE)
    dir.create(dir, showWarnings = FALSE)
  }
  create_staticdoc_folder_tree <- function(dir, subdirs) {
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
  create_staticdoc_files <- function(files, source_dir, destination) {
    from_files <- lapply(files, function(file) file.path(source_dir, file))
    destination <- file.path(destination, "staticdocs")
    to_dirs <- Map(determine_dir, rep(destination, length(files)), files)
    Map(file.copy, from_files, to_dirs, overwrite = TRUE)
  }

  staticdoc_dir <- file.path(output, "staticdocs")
  create_staticdoc_directory(staticdoc_dir)
  web_dir <- file.path(directory, "inst", "web")

  staticdoc_subdirs <- grep(".html", dir(web_dir), value = TRUE,
    fixed = FALSE, invert = TRUE)
  create_staticdoc_folder_tree(staticdoc_dir, staticdoc_subdirs)

  staticdoc_files <- dir(web_dir, recursive = TRUE)
  create_staticdoc_files(staticdoc_files, source_dir = web_dir, destination = output)
}


#' Check to see if a directory exists within the package.
#' @param directory character. The directory of the package to check for staticdocs.
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

#' Check whether the staticdocs folder exists.
#' @inheritParams dir_exists
staticdocs_folder_exists <- function(directory) {
  dir_exists(directory, "inst", "staticdocs")
}

#' Create the staticdocs directory.
#' @inheritParams dir_exists
create_staticdocs_folder <- function(directory) {
  dir_create(directory, "inst", "staticdocs")
}

#' Check whether a staticdoc index file exists.
#' @inheritParams dir_exists
staticdocs_index_exists <- function(directory) {
  staticdocs_folder_exists(directory) &&
   dir_exists(directory, "inst", "staticdocs", "index.r")
}

#' Create the staticdocs index.
#' @inheritParams dir_exists
create_staticdocs_index <- function(directory) {
  dir_create(directory, "inst", "staticdocs", "index.r")
}

#' Check whether staticdoc files have been written.
#' @inheritParams dir_exists
staticdocs_written <- function(directory) {
  dir_exists(directory, "inst", "web", "index.html")
}

#' Check whether staticdocs exist.
#' @inheritParams dir_exists
staticdocs_exist <- function(directory) {
  staticdocs_index_exists(directory) && staticdocs_written(directory)
}


#' Checks that the staticdocs package is installed.
check_for_staticdocs_package <- function() {
  if (!(is.element("pkgdown", utils::installed.packages()[, 1]))) {
    stop("You must install the pkgdown package to run pkgdown ",
      "You can get it from https://github.com/hadley/pkgdown", call. = FALSE)
  }
}
