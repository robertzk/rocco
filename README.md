Literate Documentation for R Packages [![Build Status](https://travis-ci.org/robertzk/rocco.svg?branch=master)](https://travis-ci.org/robertzk/rocco) [![Coverage Status](https://coveralls.io/repos/robertzk/rocco/badge.svg?branch=master)](https://coveralls.io/r/robertzk/rocco)
--------------------

Literate documentation for R packages in the spirit of Coffeescript's [docco](https://github.com/jashkenas/docco)
featuring syntax highlighting using [highlight.js](https://highlightjs.org/).

To document your package, simply run

```R
rocco::rocco("/path/to/package") # Will open browser interactively.

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

installation instructions
----------------

Many thanks go to

 * The [highlight.js](https://highlightjs.org/) project for the Javascript-based
   R syntax highlighting.

 * [Sindre Sorhus](https://github.com/sindresorhus) for the [Github Markdown style](https://github.com/sindresorhus/github-markdown-css).

