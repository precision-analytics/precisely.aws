context("S3")

test_that("test file is successfully uploaded", {
  expect_identical(precisely.aws.S3.put_object("./s3_test_file.txt", bucket = "precisely-aws-test"),
                   "upload: ./s3_test_file.txt to s3://precisely-aws-test/s3_test_file.txt")
})

test_that("test file appears in bucket list", {
  expect_match(precisely.aws.S3.list_objects("precisely-aws-test"),
                   ".*s3_test_file.txt")
})

test_that("test file is successfully downloaded", {
  expect_identical(precisely.aws.S3.get_object("s3_test_file.txt", "precisely-aws-test", "./tmp.txt"),
                   "download: s3://precisely-aws-test/s3_test_file.txt to ./tmp.txt")
  expect_true(file.exists("./tmp.txt"))
  expect_identical(readLines("./tmp.txt"), "DO NOT DELETE. For testing purposes only.")
  file.remove("./tmp.txt")
})

test_that("test file is successfully deleted", {
  expect_identical(precisely.aws.S3.delete_object("s3_test_file.txt", "precisely-aws-test"),
                   "delete: s3://precisely-aws-test/s3_test_file.txt")
  expect_identical(precisely.aws.S3.list_objects("precisely-aws-test"),
                   character(0))
})
