context("Cognito IdP")

user_pool_id <- "us-east-2_muIitZKBR"

test_that("test group's user list is successfully retrieved", {
  expect_identical(precisely.aws.CognitoIdp.getUsersInGroup(user_pool_id, "KisoJi-Test"),
                   "test")
})

test_that("non-existent user pool ID and user group name results in error", {
  expect_error(precisely.aws.CognitoIdp.getUsersInGroup("fake_id", "KisoJi-Test"),
               ".*User pool fake_id does not exist")
  expect_error(precisely.aws.CognitoIdp.getUsersInGroup(user_pool_id, "Fake-Group"),
               ".*Group not found")
})
