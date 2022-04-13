# AA repository folder R

Even if not using a package, we still recommend using Roxygen comments for each function, as good practice.

For example:

```
#' Add together two numbers
#' 
#' @param x A number.
#' @param y A number.
#' @return The sum of \code{x} and \code{y}.
#' @examples
#' add(1, 1)
#' add(10, 1)
add <- function(x, y) {
  x + y
}

```

This folder contains one example function called `addNums.R`. Please delete it.