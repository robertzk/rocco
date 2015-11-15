#' Writes staticdocs if they don't already exist.
write_staticdocs <- function(package_dir) {
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
    for (subdir in subdirs) {
      subdir <- file.path(dir, subdir)
      unlink(subdir, recursive = TRUE, force = TRUE)
      dir.create(subdir, showWarnings = FALSE)
    }
  }
  create_staticdoc_files <- function(files, source_dir, destination) {
    for (file in files) {
      to_dir <- file.path(destination, "staticdocs")
      from_file <- file.path(source_dir, file)
      file_split <- strsplit(file, "/")[[1]]
      if (length(file_split) > 1) {
        to_dir <- file.path(to_dir, file_split[[1]])
      }
      file.copy(from_file, to_dir, overwrite = TRUE)
    }
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
staticdocs_folder_exists <- function(directory) {
  file.exists(file.path(directory, "inst", "staticdocs"))
}

#' Check whether a staticdoc index file exists.
staticdocs_index_exists <- function(directory) {
  staticdocs_folder_exists(directory) &&
    file.exists(file.path(directory, "inst", "staticdocs", "index.r"))
}

#' Check whether staticdoc files have been written.
staticdocs_written <- function(directory) {
  file.exists(file.path(directory, "inst", "web", "index.html"))
}

#' Check whether staticdocs exist.
staticdocs_exist <- function(directory) {
  staticdocs_index_exists(directory) && staticdocs_written(directory)
}
