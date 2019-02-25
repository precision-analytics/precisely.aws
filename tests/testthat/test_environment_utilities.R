context("Environment Utilities")

# Need to source the file itself to get to internal functions
tryCatch({
  source( "../../R/environment_utilities.R")
},
warning = function(cond) {
  source( "../00_pkg_src/precisely.aws/R/environment_utilities.R")
})


test_that("instance metadata check is false for default url", {
  expect_false(internal.IsEC2())
})

test_that("instance metadata check is true for google url", {
  expect_true(internal.IsEC2("https://www.google.com"))
})

test_that("isEC2 matches instance metadata check", {
  expect_equal(precisely.aws.isEC2, internal.IsEC2())
})

test_that("isEC2 is false locally", {
  expect_false(precisely.aws.isEC2)
})

