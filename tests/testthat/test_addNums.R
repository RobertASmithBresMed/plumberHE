# test to check that addNums matches the 'sum' function...
for(i in 1:10){
  
  x <- runif(n = 1,
             min = 0,
             max = 100)
  y <- runif(n = 1,
             min = 0,
             max = 100)
  
testthat::test_that(desc = "Add 2 and 1 together",
                    code = {
                      testthat::expect_equal(addNums(x, y),
                                             sum(x, y))
                    })
  
}
