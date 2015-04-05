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
rocco <- function(directory, output_dir, browse) {

}