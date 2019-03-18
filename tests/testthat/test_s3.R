context("S3")

test_that("test file is successfully uploaded", {
  expect_identical(precisely.aws.S3.put_object("./s3/s3_test_file.txt", bucket = "precisely-aws-test"),
                   "upload: s3/s3_test_file.txt to s3://precisely-aws-test/s3_test_file.txt")
})

test_that("test file appears in bucket list", {
  objects_tbl <- precisely.aws.S3.list_objects("precisely-aws-test")
  expect_identical(objects_tbl$file_name, "s3_test_file.txt")
})

test_that("test file is successfully downloaded", {
  expect_identical(precisely.aws.S3.get_object("s3_test_file.txt",
                                               "precisely-aws-test",
                                               "./tmp.txt"),
                   "download: s3://precisely-aws-test/s3_test_file.txt to ./tmp.txt")
  expect_true(file.exists("./tmp.txt"))
  expect_identical(readLines("./tmp.txt"), "DO NOT DELETE. For testing purposes only.")
  file.remove("./tmp.txt")
})

test_that("test file is successfully deleted", {
  expect_identical(precisely.aws.S3.delete_object("s3_test_file.txt", "precisely-aws-test"),
                   "delete: s3://precisely-aws-test/s3_test_file.txt")
  expect_null(precisely.aws.S3.list_objects("precisely-aws-test"))
})

test_that("test file is successfully uploaded with prefix", {
  expect_identical(precisely.aws.S3.put_object("./s3/s3_test_file.txt",
                                               bucket = "precisely-aws-test",
                                               prefix = "prefix_test"),
                   "upload: s3/s3_test_file.txt to s3://precisely-aws-test/prefix_test/s3_test_file.txt")
})

test_that("test file appears in bucket list with prefix", {
  objects_tbl <- precisely.aws.S3.list_objects("precisely-aws-test", prefix = "prefix_test")
  print(objects_tbl)
  expect_identical(objects_tbl$file_name, "prefix_test/s3_test_file.txt")
})

test_that("test file is successfully downloaded with prefix", {
  expect_identical(precisely.aws.S3.get_object("s3_test_file.txt",
                                               "precisely-aws-test",
                                               "./tmp.txt",
                                               prefix = "prefix_test"),
                   "download: s3://precisely-aws-test/prefix_test/s3_test_file.txt to ./tmp.txt")
  expect_true(file.exists("./tmp.txt"))
  expect_identical(readLines("./tmp.txt"), "DO NOT DELETE. For testing purposes only.")
  file.remove("./tmp.txt")
})

test_that("test file is successfully deleted with prefix", {
  expect_identical(precisely.aws.S3.delete_object("s3_test_file.txt",
                                                  "precisely-aws-test",
                                                  prefix = "prefix_test"),
                   "delete: s3://precisely-aws-test/prefix_test/s3_test_file.txt")
  expect_null(precisely.aws.S3.list_objects("precisely-aws-test"))
})

test_that("test directory is successfully uploaded", {
  # Upload the directory
  expect_identical(precisely.aws.S3.put_object("./s3/s3_test_file.txt", bucket = "precisely-aws-test"),
                   "upload: s3/s3_test_file.txt to s3://precisely-aws-test/s3_test_file.txt")
  # Verify the test file is in the bucket
  objects_tbl <- precisely.aws.S3.list_objects("precisely-aws-test")
  expect_identical(objects_tbl$file_name, "s3_test_file.txt")
  # Delete the test file from the bucket
  expect_identical(precisely.aws.S3.delete_object("s3_test_file.txt", "precisely-aws-test"),
                   "delete: s3://precisely-aws-test/s3_test_file.txt")
  expect_null(precisely.aws.S3.list_objects("precisely-aws-test"))
})
