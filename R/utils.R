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

commit_to_gh_pages <- function(directory, dir) {
  ## A little bit of git magic

  ## Now that we have the docs, we need to transfer them to the gh-pages
  ## branch of the repo, commit and push.
  ## Switch to gh-pages branch
  cur_branch <- system('git rev-parse --abbrev-ref HEAD', intern = TRUE)
  on.exit({
    system(paste('git checkout', cur_branch))
  })

  st <- system2('git', 'checkout gh-pages')
  if (st == 1) system2('git', 'checkout -b gh-pages')

  ## Copy the docs to the repo folder, and push them upstream
  system(paste0('cp -rf ', dir, "/* ", directory))
  in_dir(directory, {
    system('git add -A .')
    system('git commit -m "Updated Rocco docs."')
    system('git push origin gh-pages')
  })
  invisible(TRUE)
}

## Don't want to import devtools because of in_dir
in_dir <- function(new, code) {
  old <- setwd(new)
  on.exit(setwd(old))
  force(code)
}
