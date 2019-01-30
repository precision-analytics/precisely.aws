
library(testthat)
library(precisely.aws)

# Need to source the file itself to get to internal functions
tryCatch({
  source( "../R/secrets_manager.R")
},
warning = function(cond) {
  source( "../00_pkg_src/precisely.aws/R/secrets_manager.R")
})

test_that("test secret is successfully retrieved and parsed", {
  expectedSecretValue <- list(username = "secretstest", password = "secretstest")
  expect_identical(precisely.aws.SecretsManager.getSecretValue("dev/precisely.aws/secrets_test"),
                   expectedSecretValue)
})

test_that("empty and non-existent secret names result in errors", {
  expect_error(precisely.aws.SecretsManager.getSecretValue(),
               "aws command not found, failing")
  expect_error(precisely.aws.SecretsManager.getSecretValue("fake/secret"),
               "failed to run aws command, verify secret name")
})
