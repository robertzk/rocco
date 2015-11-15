#' Writes staticdocs if they don't already exist.
write_staticdocs <- function(package_dir) {
  check_for_staticdocs_package()
  if (!staticdocs_index_exists(package_dir)) {
    if (!staticdocs_folder_exists(package_dir)) {
      dir.create(file.path(package_dir, "staticdocs"), showWarnings = FALSE)
    }
    file.create(file.path(package_dir, "staticdocs", "index.r"))
  }
  staticdocs::build_site(package_dir, launch = FALSE)
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
    file_split <- strsplit(file, "/")[[1]]
    if (length(file_split) > 1) {
      file.path(dir, file_split[[1]])
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


#' Check whether the staticdocs folder exists.
#' @param directory character. The directory of the package to check for staticdocs.
staticdocs_folder_exists <- function(directory) {
  file.exists(file.path(directory, "inst", "staticdocs"))
}

#' Check whether a staticdoc index file exists.
#' @param directory character. The directory of the package to check for staticdocs.
staticdocs_index_exists <- function(directory) {
  staticdocs_folder_exists(directory) &&
    file.exists(file.path(directory, "inst", "staticdocs", "index.r"))
}

#' Check whether staticdoc files have been written.
#' @param directory character. The directory of the package to check for staticdocs.
staticdocs_written <- function(directory) {
  file.exists(file.path(directory, "inst", "web", "index.html"))
}

#' Check whether staticdocs exist.
#' @param directory character. The directory of the package to check for staticdocs.
staticdocs_exist <- function(directory) {
  staticdocs_index_exists(directory) && staticdocs_written(directory)
}


#' Checks that the staticdocs package is installed.
check_for_staticdocs_package <- function() {
  if (!(is.element("staticdocs", utils::installed.packages()[, 1]))) {
    stop("You must install the staticdocs package to run staticdocs. ",
      "You can get it from https://github.com/hadley/staticdocs.", call. = FALSE)
  }
}
