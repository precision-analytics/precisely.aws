#' Verifies a connection to a given URL. Requests the instance identity document from the
#' EC2 Instance Metadata service by default.
#'
#' @seealso https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/identify_ec2_instances.html
#'
#' @param url A URL to query.
#'
#' @return Returns TRUE if the URL request succeeds, otherwise FALSE
#'
#' @importFrom httr GET timeout
#'
#' @keywords internal
internal.IsEC2 <- function(url="http://169.254.169.254/latest/dynamic/instance-identity/") {
  return(tryCatch(
    {
      response <- GET(url, timeout(2))
      return(TRUE)
    },
    error = function(cond) {
      return(FALSE)
    },
    warning = function(cond) {
      return(FALSE)
    }
  ))
}

#' Checks for EC2 Instance Metadata to verify if currently running on EC2
#'
#' @export
#'
#' @return Returns TRUE if the metadata service responds, otherwise FALSE
precisely.aws.isEC2 <- ifelse(internal.IsEC2() == TRUE, TRUE, FALSE)
