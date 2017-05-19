#' Apply Rocco Documentation to a Package.
#'
#' Given a local package directory, turn the package's R files
#' into a literately documented website.
#'
#' @param directory character. The package directory to document.
#' @param output_dir character. The directory to output the static HTML site.
#'    By default, an extemporaneously-generated temporary directory.
#' @param browse logical. Whether or not to launch the documentation
#'    immediately for browsing. This will be set to \code{\link{interactive}()},
#'    that is, TRUE if the R session is running interactive and FALSE
#'    otherwise.
#' @param rocco logical. Whether or not to create rocco docs.  Defaults to \code{TRUE}.
#' @param pkgdown logical. Whether or not to create pkgdown.  Staticdocs are
#'    from Hadley's \href{https://github.com/hadley/pkgdown}{pkgdown package}.
#"    Defaults to \code{TRUE}.
#' @param gh_pages logical. If set to true, rocco docs will be served on
#'    your gh-pages branch.
#' @export
#' @return TRUE, plus additional side effects are the creation of the
#'    documentation in the \code{output_dir} and the launching of the browser if
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
rocco <- function(directory, output_dir = tempdir(), browse = interactive(),
  rocco = TRUE, pkgdown = TRUE, gh_pages = FALSE) {
  if (missing(directory)) directory <- "."
  stopifnot(is.character(directory), length(directory) == 1,
            is.character(output_dir), length(output_dir) == 1,
            is_package_directory(directory))

  if (isTRUE(pkgdown)) { write_pkgdown(directory) }

  if (isTRUE(rocco)) { write_rocco_docs(directory, output_dir) }

  if (isTRUE(gh_pages) && isTRUE(rocco)) {
    #TODO: Be able to push *just* pkgdown to gh-pages.
    commit_to_gh_pages(directory, output_dir)
  }

  if (isTRUE(browse)) {
    if (isTRUE(rocco)) { browseURL(file.path(output_dir, "index.html")) }
    if (isTRUE(pkgdown)) { browseURL(file.path(output_dir, "pkgdown", "index.html")) }
  }
  invisible(TRUE)
}


write_rocco_docs <- function(directory, output) {
  rocco_skeleton(directory, output)

  template <- readLines(file.path(output, "index.html"))
  compile(directory, template, file.path(output, "index.html"))
}
