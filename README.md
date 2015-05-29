Literate Docs for R Packages [![Build Status](https://travis-ci.org/robertzk/rocco.svg?branch=master)](https://travis-ci.org/robertzk/rocco) [![Documentation](https://img.shields.io/badge/rocco--docs-%E2%9C%93-blue.svg)](http://robertzk.github.io/rocco/)
--------------------

Literate documentation for R packages in the spirit of Coffeescript's [docco](https://github.com/jashkenas/docco)
featuring syntax highlighting using [highlight.js](https://highlightjs.org/).

To document your package, simply run

```R
rocco::rocco("/path/to/package") # Will open browser interactively.

# This will build the docs and push them to the repos gh-pages branch
rocco::rocco("/path/to/package", gh_pages = TRUE)

# This will install the rocco docs to /path/to/pkg/inst/docs/rocco
rocco::rocco("/path/to/pkg", "/path/to/pkg/inst/docs/rocco", browse = FALSE)
```

Installation
------------

This package is not yet available from CRAN (as of April 4, 2015).
To install the latest development builds directly from GitHub, run this instead:

```R
if (!require("devtools")) install.packages("devtools")
devtools::install_github("robertzk/rocco")
```

Acknowledgements
----------------

Many thanks go to

 * The [highlight.js](https://highlightjs.org/) project for the Javascript-based
   R syntax highlighting.

 * [Sindre Sorhus](https://github.com/sindresorhus) for the [Github Markdown style](https://github.com/sindresorhus/github-markdown-css).

 * [Jeremy Ashkenas](https://github.com/jashkenas) for [the original](https://github.com/jashkenas/docco) inspiration.
