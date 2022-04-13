#' addNums
#' 
#' param a is a single numeric value of length 1
#' param b is a single numeric value of length 1
#' 
#' returns numeric with length 1
#' 
#' Example:
#' addNums(1, 2)
#' # 3
#' 
addNums <- function(a, b){
  
  # tests check
  stopifnot(class(a) == "numeric")
  stopifnot(length(a) == 1)
  
  #calculation
  c <- a + b
  
  return(c)
  
}