#' Copy a local file to an S3 object.
#'
#' @param file The name of, or full path to, the file to upload.
#' @param object The name the object should have in S3 (optional, defaults to the file name).
#' @param bucket The name of the S3 bucket to create the object in.
precisely.aws.S3.put_object <- function(file, object, bucket) {
  if (missing(object)) {
    object <- basename(file)
  }

  args <- c("s3", "cp", file, paste0("s3://", bucket, "/", object), "--no-progress")

  execute_aws_cmd(args)
}


#' Copy an S3 object to a local file.
#'
#' @param object The name of the S3 object to download.
#' @param bucket The name of the S3 bucket the object is located in.
#' @param file The name of, or full path to, the local file to save the downloaded object in.
precisely.aws.S3.get_object <- function(object, bucket, file) {
  args <- c("s3", "cp", paste0("s3://", bucket, "/", object), file, "--no-progress")

  execute_aws_cmd(args)
}


#' Delete an S3 object.
#'
#' @param object The name of the S3 object to delete
#' @param bucket The name of the S3 bucket the object is located in.
precisely.aws.S3.delete_object <- function(object, bucket) {
  args <- c("s3", "rm", paste0("s3://", bucket, "/", object))

  execute_aws_cmd(args)
}


#' List objects and common prefixes under a specified S3 bucket.
#'
#' @param bucket The name of the S3 bucket.
#' @param recursive If TRUE, will recursively list objects in a bucket.
#' That is, rather than showing PRE dirname/ in the output, all the content in a bucket will be
#' listed in order. Optional, default is TRUE.
precisely.aws.S3.list_objects <- function(bucket, recursive = TRUE) {
  args <- c("s3", "ls", paste0("s3://", bucket), "--human-readable")

  if (recursive) {
    args <- c(args, "--recursive")
  }

  execute_aws_cmd(args)
}
