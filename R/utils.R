`%||%` <- function(x, y) if (is.null(x)) y else x

isFALSE <- function(x) identical(x, FALSE)

is_package_directory <- function(dir) {
  all(file.exists(file.path(dir, c("DESCRIPTION", "R"))))
}

rocco_file <- function(file) {
  system.file(file, package = "rocco")
}

package_description <- function(pkg_path) {
  description_file_attribute(pkg_path, "Description")
}

package_title <- function(pkg_path) {
  description_file_attribute(pkg_path, "Title")
}

description_file_attribute <- function(pkg_path, attribute) {
  as.character(read.dcf(file.path(pkg_path, "DESCRIPTION"))[1, attribute])
}

