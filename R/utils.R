`%||%` <- function(x, y) if (is.null(x)) y else x

isFALSE <- function(x) identical(x, FALSE)

is_package_directory <- function(dir) {
  all(file.exists(file.path(dir, c("DESCRIPTION", "R"))))
}

