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
    rocco_file(file.path("templates", "index.html")),
      file.path(dir, "index.html")
  )

  destinations <- file_map[c(FALSE, TRUE)]
  sources <- file_map[c(TRUE, FALSE)]

  lapply(destinations, unlink, force = TRUE, recursive = TRUE)
  lapply(dirname(destinations), dir.create, recursive = TRUE, showWarnings = FALSE)

  suppressWarnings(Map(file.copy, sources, destinations, overwrite = TRUE))

  if (staticdocs_exist()) { load_staticdocs(dir) }
}
