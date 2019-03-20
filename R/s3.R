#' Copy a local file to an S3 object.
#'
#' @export
#'
#' @param path The relative or full path to the file or directory to upload.
#' @param object If \code{path} is a file, the name the object should have in S3
#' (optional, defaults to the file name).
#' @param bucket The name of the S3 bucket to create the object(s) in.
#' @param prefix The prefix to use for the file in the S3 bucket (optional).
#'
#' @return A character vector containing the success message.
precisely.aws.S3.put_object <- function(path, object, bucket, prefix = NULL) {
  if (missing(object)) {
    object <- basename(path)
  }

  args <- c("s3", "cp", path)

  s3_path <- paste0("s3://", bucket, "/")

  if (!is.null(prefix)) {
    s3_path <- paste0(s3_path, prefix, "/")
  }

  if (dir.exists(path)) {
    args <- c(args, s3_path, "--recursive", "--no-progress")
  } else {
    args <- c(args, paste0(s3_path, object), "--no-progress")
  }

  execute_aws_cmd(args)
}


#' Copy an S3 object to a local file.
#'
#' @export
#'
#' @param object The name of the S3 object to download.
#' @param bucket The name of the S3 bucket the object is located in.
#' @param file The name of, or full path to, the local file to save the downloaded object in.
#' @param prefix The prefix applied to the S3 object when uploaded (optional).
#'
#' @return A character vector containing the success message.
precisely.aws.S3.get_object <- function(object, bucket, file, prefix = NULL) {
  s3_path <- paste0("s3://", bucket, "/")

  if (!is.null(prefix)) {
    s3_path <- paste0(s3_path, prefix, "/")
  }

  args <- c("s3", "cp", paste0(s3_path, object), file, "--no-progress")

  execute_aws_cmd(args)
}


#' Delete an S3 object.
#'
#' @export
#'
#' @param object The name of the S3 object to delete
#' @param bucket The name of the S3 bucket the object is located in.
#' @param prefix The prefix applied to the S3 object when uploaded (optional).
#'
#' @return A character vector containing the success message.
precisely.aws.S3.delete_object <- function(object, bucket, prefix = NULL) {
  s3_path <- paste0("s3://", bucket, "/")

  if (!is.null(prefix)) {
    s3_path <- paste0(s3_path, prefix, "/")
  }

  args <- c("s3", "rm", paste0(s3_path, object))

  execute_aws_cmd(args)
}


#' List objects and common prefixes under a specified S3 bucket.
#'
#' @export
#'
#' @param bucket The name of the S3 bucket.
#' @param recursive If TRUE, will recursively list objects in a bucket.
#' That is, rather than showing PRE dirname/ in the output, all the content in a bucket will be
#' listed in order. Optional, default is TRUE.
#'
#' @return A \code{\link[tibble]{tibble}} of the objects in the bucket and their associated file information.
#'
#' @importFrom dplyr %>% bind_cols rename select
#' @importFrom tibble rownames_to_column
#' @importFrom tidyr gather spread
precisely.aws.S3.list_objects <- function(bucket, recursive = TRUE, prefix = NULL) {
  s3_path <- paste0("s3://", bucket)

  if (!is.null(prefix)) {
    s3_path <- paste0(s3_path, "/", prefix)
  }

  args <- c("s3", "ls", s3_path, "--human-readable")

  if (recursive) {
    args <- c(args, "--recursive")
  }

  file_list <- execute_aws_cmd(args)
  if (!identical(file_list, character(0))) {
    file_props <- sapply(file_list, function(x) strsplit(x, split = "\\s+"))
    bind_cols(file_props) %>%
      rownames_to_column() %>%
      gather(var, value, -rowname) %>%
      spread(rowname, value) %>%
      select(-var) %>%
      rename(last_write_date = `1`,
             last_write_time = `2`,
             size = `3`,
             size_unit = `4`,
             file_name = `5`)
  } else {
    NULL
  }
}
