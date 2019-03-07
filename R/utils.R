execute_aws_cmd <- function(args) {
  error_log <- paste0(tempdir(), "error.log")

  tryCatch(
    {
      system2("aws", args = args, stdout = TRUE, stderr = error_log)
    },
    error = function (cond) {
      stop("aws command not found, failing")
    },
    warning = function (cond) {
      error_msg <- readr::read_lines(error_log, skip_empty_rows = TRUE)
      stop(error_msg)
    }
  )
}
