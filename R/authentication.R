#' Gets the instance metadata URL for a given IAM role. This function only
#' generates the URL, you must query it separately to verify if the role exists.
#'
#' @keywords internal
internal.GetURLForRole <- function(role) {
  baseURL <- "http://169.254.169.254/latest/meta-data/iam/security-credentials/"
  roleURL <- paste(baseURL, role, sep = "")
  return(roleURL)
}


#' Sets environmental variables for:
#'   AWS_ACCESS_KEY_ID
#'   AWS_SECRET_ACCESS_KEY
#'
#' These are standard, used by the aws cli tools and other libraries like cloudyr
#'
#' @keywords internal
internal.SetAWSEnvironmentVariables <- function(accessKey, secretKey) {
  emptyString <- function(string) {
    if (string == "" || is.null(string) || is.na(string)) {
      return(TRUE)
    } else {
      return(FALSE)
    }
  }

  if (!emptyString(accessKey) && !emptyString(secretKey)) {
    Sys.setenv("AWS_ACCESS_KEY_ID" = accessKey,
               "AWS_SECRET_ACCESS_KEY" = secretKey)
  }
}


#' Fetches and sets access keys from ~/.aws/credentials. Uses the first
#' keypair found.
#'
#' @keywords internal
internal.GetAndSetLocalKeys <- function() {
  path <- "~/.aws/credentials"
  keys <- read.delim(path, header = FALSE, sep = "=", skip = 1)

  if (length(keys$V2) != 2) {
    stop("Local keys not found, failing")
  } else {
    accessKey = keys$V2[[1]]
    secretKey = keys$V2[[2]]

    internal.SetAWSEnvironmentVariables(accessKey, secretKey)
  }
}


#' Fetches and sets access keys for a given IAM role. Role must be authorized
#' with the EC2 instance. Keys are set as environment variables.
#'
#' @seealso https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html?shortFooter=true#instance-metadata-security-credentials
#'
#' @export
#'
#' @param role The IAM Role to assume.
#'
#' @importFrom httr content GET status_code
#' @importFrom jsonlite fromJSON
precisely.aws.IAM.AssumeRole <- function(role) {
  if (precisely.aws.isEC2) {
    response <- GET(internal.GetURLForRole(role), timeout(4))

    if (status_code(response) != 200) {
      stop("IAM role not found or not authorized")
    } else {
      metadata <- fromJSON(content(response, "text", encoding = "UTF-8"))

      accessKey = metadata$AccessKeyId
      secretKey = metadata$SecretAccessKey

      internal.SetAWSEnvironmentVariables(accessKey, secretKey)
    }
  } else {
    internal.GetAndSetLocalKeys()
  }
}
