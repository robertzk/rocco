# Version 0.2.1.2
  * If the `inst` directory itself doesn't exist, it will be created.
  * Refactoring the file checking and creation logic.

# Version 0.2.1.1

  * Fixes location of the pkgdown file written by Rocco.
  * Doesn't move the same directory multiple times.

# Version 0.2.1

  * Rocco now will call Roxygen documentation prior to compiling pkgdown.

# Version 0.2
  
  * Now Rocco also generates [pkgdown](https://github.com/hadley/pkgdown).  It creates all the necessary pre-files for pkgdown so you don't have to build them yourself.
  * This repo now has pkgdown.
  * Removed pending files.

# Version 0.1.1

  * Added the ability to push the generated documentation to the
    [gh-pages](https://robertzk.github.io/rocco) branch of your repo.
    When calling `rocco::rocco`, set `gh_pages = TRUE`.

# Version 0.1.0

  * The initial creation of the package.
