#' Writes staticdocs if they don't already exist.
`write_staticdocs!` <- function() {
  package_dir <- system.file(package = "rocco")
  if (!staticdocs_index_exists()) {
    if (!staticdocs_folder_exists()) {
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
#' @param dir character. The directory of the Rocco skeleton.
load_staticdocs <- function(dir) {
  create_staticdoc_directory <- function(dir) {
    unlink(dir, recursive = TRUE, force = TRUE)
    dir.create(dir, showWarnings = FALSE)
  }
  create_staticdoc_folder_tree <- function(dir, subdirs) {
    for (subdir in subdirs) {
      subdir <- file.path(dir, subdir)
      unlink(subdir, recursive = TRUE, force = TRUE)
      dir.create(subdir, showWarnings = FALSE)
    }
  }
  create_staticdoc_files <- function(files, dir) {
    for (file in files) {
      from_file <- rocco_file(file.path("web", file))
      file_split <- strsplit(file, "/")[[1]]
      to_dir <- if (length(file_split) > 1) {
        file.path(dir, file_split[[1]])
      } else { dir }
      file.copy(from_file, to_dir, overwrite = TRUE)
    }
  }

  staticdoc_dir <- file.path(dir, "staticdocs")
  create_staticdoc_directory(staticdoc_dir)

  staticdoc_subdirs <- grep(".html", dir(rocco_file("web")), value = TRUE,
    fixed = FALSE, invert = TRUE)
  create_staticdoc_folder_tree(staticdoc_dir, staticdoc_subdirs)

  staticdoc_files <- dir(rocco_file("web"), recursive = TRUE)
  create_staticdoc_files(staticdoc_files, staticdoc_dir)
}


#' Check whether the staticdocs folder exists.
staticdocs_folder_exists <- function() {
  nzchar(rocco_file("staticdocs"))
}

#' Check whether a staticdoc index file exists.
staticdocs_index_exists <- function() {
  staticdocs_folder_exists() &&
    nzchar(rocco_file(file.path("staticdocs", "index.r")))
}

#' Check whether staticdoc files have been written.
staticdocs_written <- function() {
  nzchar(rocco_file(file.path("web", "index.html")))
}

#' Check whether staticdocs exist.
staticdocs_exist <- function() {
  staticdocs_index_exists() && staticdocs_written()
}
