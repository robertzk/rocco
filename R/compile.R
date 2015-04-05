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
  list(
    package_description = gsub("[[:space:]]+", " ", package_description(pkg_dir)),
    package_title = package_title(pkg_dir),
    sections = package_sections(pkg_dir)
  )
}

package_sections <- function(pkg_dir) {
  do.call(c, lapply(
    list.files(file.path(pkg_dir, "R"), full.names = TRUE), 
    file_section
  ))
}

file_section <- function(file) {
  lines <- readLines(file)

  c(
    list(file_header(file)),
    rocco_sections(lines)
  )
}

file_header <- function(file) {
  list(commentary = markdown_to_html(paste0("# ", basename(file))), code = "")
}

rocco_sections <- function(lines) {
  rocco_lines <- rocco_lines(lines)
  unname(tapply(
    lines,
    cumsum(diff(c(FALSE, rocco_lines)) == 1),
    FUN = rocco_section
  ))
}

rocco_regex <- "^[[:space:]]*##( |$)"

rocco_lines <- function(lines) {
  grepl(rocco_regex, lines)
}

rocco_section <- function(lines) {
  section <- split(lines, rocco_lines(lines))
  list(
    commentary = rocco_commentary(section$`TRUE` %||% character(0)),
    code       = paste(section$`FALSE` %||% character(0), collapse = "\n")
  )
}

rocco_commentary <- function(lines) {
  markdown_to_html(paste(gsub(rocco_regex, "", lines), collapse = "\n"))
}

markdown_to_html <- function(text) {
  if (length(text) > 0 && nzchar(text)) {
    markdown::markdownToHTML(text = text, fragment.only = TRUE)
  } else ""
}

