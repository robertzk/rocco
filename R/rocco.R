#' Apply Rocco Documentation to a Package.
#'
#' Given a local package directory, turn the package's R files
#' into a literately documented website.
#'
#' @param directory character. The package directory to document.
#' @param output_dir character. The directory to output the static HTML site.
#'    By default, an extemporaneously-generated temporary directory.
#' @param browse logical. Whether or not to launch the documentation
#'    immediately for browsing. This will be set to \code{\link{interactive()}},
#'    that is, TRUE if the R session is running interactive and FALSE
#'    otherwise.
#' @export
#' @return TRUE or FALSE according as the documentation process succeeds.
#     Additional side effects are the creation of the documentation in the
#'    \code{output_dir} and the launching of the browser if
#'    \code{browse = TRUE}.
#' @examples
#' \dontrun{
#'   rocco("/path/to/package") # Will create a temporary directory and
#'     # display literate documentation for everything in the R directory
#'     # of the package at /path/to/package.
#'
#'   # The below will simply create a static HTML site without opening it.
#'   rocco("/path/to/package", output_dir = "/my/html/dir", browse = FALSE)
#' }
rocco <- function(directory, output_dir = tempdir(), browse = interactive()) {
  stopifnot(is.character(directory), length(directory) == 1,
            is.character(output_dir), length(output_dir) == 1,
            isTRUE(browse) || isFALSE(browse),
            is_package_directory(directory))

  tryCatch({
    rocco_(directory, output_dir)

    if (browse) browseURL(file.path(output_dir, "index.html"))

    TRUE
  }, error = function(.) FALSE)
}

rocco_ <- function(directory, output) {
  rocco_skeleton(output) 

  compile(directory, file.path(output, "index.html"))
}

rocco_skeleton <- function(dir) {
  dir.create(dir, FALSE, TRUE)

  file_map <- list(
    rocco_file(file.path("www", "highlight", "highlight.pack.js")),
    file.path(dir, "assets", "highlight.pack.js"),
    rocco_file(file.path("www", "highlight", "styles", "docco.css")),
    file.path(dir, "stylesheets", "rocco.css"),
    rocco_file(file.path("templates", "index.html")),
    file.path(dir, "index.html")
  )

  Map(file.copy, file_map[c(TRUE, FALSE)], file_map[c(FALSE, TRUE)],
      recursive = TRUE, overwrite = TRUE)
}

compile <- function(pkg_dir, template) {
  writeLines(whisker::whisker.render(template, rocco_data(pkg_dir)), template)
}

rocco_data <- function(pkg_dir) {
  # TODO: (RK) Fill this in.
  list(
    package_description = gsub("[[:space:]]+", " ", package_description(pkg_dir)),
    package_title = package_title(pkg_dir),
    rocco_output = "Howdy neighbor"
  )
}



