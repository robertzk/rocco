#' Compile a Rocco Page From a Template.
#' 
#' @param pkg_dir character. A package directory with rocco-documented R files.
#' @param template character. The whisker template to use.
#' @param out_file character. The output file.
compile <- function(pkg_dir, template, out_file) {
  writeLines(whisker::whisker.render(
   template, rocco_data(pkg_dir)
  ), out_file)
}

rocco_data <- function(pkg_dir) {
  # TODO: (RK) Fill this in.
  list(
    package_description = gsub("[[:space:]]+", " ", package_description(pkg_dir)),
    package_title = package_title(pkg_dir),
    sections = list(
      list(
        commentary = markdown::markdownToHTML(fragment.only = TRUE, text = "# How's it going?\n\nI am markdown!"),
        code       = "library('test')\nfoo <- function(a, b) {\n  a + b\n}\ncat('Hi!')"
      ),

      list(
        commentary = markdown::markdownToHTML(fragment.only = TRUE, text = "# How's it going?\n\nI am more markdown!"),
        code       = "library('test')\nfoo <- function(a, b, c) {\n  a + b - c\n}\ncat('Hello')"
      )
    )
  )
}


