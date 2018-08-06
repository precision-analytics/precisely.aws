
library(testthat)
library(precisely.aws)

# Need to source the file itself to get to internal functions
tryCatch({
  source("../R/authentication.R")
},
warning = function(cond) {
  source("R/authentication.R")
},
error = function(cond) {
  source("R/authentication.R")
}
)


test_that("role URL gets properly generated", {
  expect_equal(internal.GetURLForRole("testrole"), "http://169.254.169.254/latest/meta-data/iam/security-credentials/testrole")
})

test_that("environment variables get set", {
  internal.SetAWSEnvironmentVariables("access_key", "secret_key")
  expect_equal(Sys.getenv("AWS_ACCESS_KEY_ID"), "access_key")
  expect_equal(Sys.getenv("AWS_SECRET_ACCESS_KEY"), "secret_key")
})

test_that("environment variables get overwritten", {
  internal.SetAWSEnvironmentVariables("access_key", "secret_key")
  expect_equal(Sys.getenv("AWS_ACCESS_KEY_ID"), "access_key")
  expect_equal(Sys.getenv("AWS_SECRET_ACCESS_KEY"), "secret_key")

  internal.SetAWSEnvironmentVariables("access_new", "secret_new")
  expect_equal(Sys.getenv("AWS_ACCESS_KEY_ID"), "access_new")
  expect_equal(Sys.getenv("AWS_SECRET_ACCESS_KEY"), "secret_new")
})

test_that("empty keys do not get set", {
  internal.SetAWSEnvironmentVariables("access_key", "secret_key")
  internal.SetAWSEnvironmentVariables("", NULL)
  expect_equal(Sys.getenv("AWS_ACCESS_KEY_ID"), "access_key")
  expect_equal(Sys.getenv("AWS_SECRET_ACCESS_KEY"), "secret_key")
})


