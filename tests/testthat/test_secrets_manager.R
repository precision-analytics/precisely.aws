context("Secrets Manager")

test_that("test secret is successfully retrieved and parsed", {
  expectedSecretValue <- list(username = "secretstest", password = "secretstest")
  expect_identical(precisely.aws.SecretsManager.getSecretValue("dev/precisely.aws/secrets_test"),
                   expectedSecretValue)
})

test_that("empty and non-existent secret names result in errors", {
  expect_error(precisely.aws.SecretsManager.getSecretValue(),
               "aws command not found, failing")
  expect_error(precisely.aws.SecretsManager.getSecretValue("fake/secret"),
               ".*Secrets Manager can’t find the specified secret")
})
