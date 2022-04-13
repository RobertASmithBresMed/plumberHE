rm(list = ls())

miceadds::source.all("R")

testthat::test_dir(path = "tests/testthat")

