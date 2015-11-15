#' Create a Skeleton for Rocco Documentation.
#'
#' Given a target directory, this will copy over the necessary assets to
#' create the initial docco template.
#'
#' @param directory character. The directory Rocco is running in.
#' @param output character. The directory to create the skeleton in.
rocco_skeleton <- function(directory, output) {
  dir.create(output, showWarnings = FALSE, recursive = TRUE)

  ## List of existing files and where they should be moved to.
  file_map <- c(
    rocco_file(file.path("www", "github-markdown-css", "github-markdown.css")),
      file.path(output, "stylesheets", "github-markdown.css"),
    rocco_file(file.path("www", "highlight", "highlight.pack.js")),
      file.path(output, "assets", "highlight.pack.js"),
    rocco_file(file.path("www", "highlight", "styles", "docco.css")),
      file.path(output, "stylesheets", "rocco.css"),
    rocco_file(file.path("templates", "index.html")),
      file.path(output, "index.html")
  )

  destinations <- file_map[c(FALSE, TRUE)]
  sources <- file_map[c(TRUE, FALSE)]

  lapply(destinations, unlink, force = TRUE, recursive = TRUE)
  lapply(unique(dirname(destinations)), dir.create, recursive = TRUE, showWarnings = FALSE)

  suppressWarnings(Map(file.copy, sources, destinations, overwrite = TRUE))

  if (staticdocs_exist(directory)) { load_staticdocs(directory, output) }
}
