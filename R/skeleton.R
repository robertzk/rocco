#' Create a Skeleton for Rocco Documentation.
#'
#' Given a target directory, this will copy over the necessary assets to
#' create the initial docco template.
#'
#' @param dir character. The directory to create the skeleton in.
rocco_skeleton <- function(dir) {
  dir.create(dir, showWarnings = FALSE, recursive = TRUE)

  ## List of existing files and where they should be moved to.
  file_map <- c(
    rocco_file(file.path("www", "github-markdown-css", "github-markdown.css")),
      file.path(dir, "stylesheets", "github-markdown.css"),
    rocco_file(file.path("www", "highlight", "highlight.pack.js")),
      file.path(dir, "assets", "highlight.pack.js"),
    rocco_file(file.path("www", "highlight", "styles", "docco.css")),
      file.path(dir, "stylesheets", "rocco.css"),
    rocco_file(file.path("www", "highlight", "styles", "docco.css")),
      file.path(dir, "stylesheets", "rocco.css"),
    rocco_file(file.path("templates", "index.html")),
      file.path(dir, "index.html")
  )

  destinations <- file_map[c(FALSE, TRUE)]
  sources <- file_map[c(TRUE, FALSE)]

  lapply(destinations, unlink, force = TRUE, recursive = TRUE)
  lapply(dirname(destinations), dir.create, recursive = TRUE, showWarnings = FALSE)

  suppressWarnings(Map(file.copy, sources, destinations, overwrite = TRUE))

  staticdocs_exist <- nzchar(rocco:::rocco_file(file.path("web", "index.html")))
  if (staticdocs_exist) { load_staticdocs(dir) }
}


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

