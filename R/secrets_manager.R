library(jsonlite)


#' Retrieves the contents of the encrypted field SecretString from the specified version of a secret
#' using the AWS CLI.
#'
#' @seealso https://docs.aws.amazon.com/cli/latest/reference/secretsmanager/get-secret-value.html
#'
#' @param secretId The ARN or the friendly name of the secret.
#' @param versionId The ID of of the version of the secret to retrieve (optional).
#' @param versionStage The staging label attached to the version of the secret to retrieve (optional).
#' @return list of the parsed JSON of the SecretString
precisely.aws.SecretsManager.getSecretValue <- function(secretId, versionId, versionStage) {
  output <- tryCatch(
    {
      args <- c("secretsmanager", "get-secret-value", "--secret-id", secretId)
      if (!missing(versionId)) {
        args <- c(args, "--version-id", versionId)
      }
      if (!missing(versionStage)) {
        args <- c(args, "--version-stage", versionStage)
      }
      system2("aws", args = args, stdout = TRUE)
    },
    error = function (cond) {
      stop("aws command not found, failing")
    },
    warning = function (cond) {
      stop("failed to run aws command, verify secret name")
    }
  )

  jsonOutput <- tryCatch(
    {
      jsonlite::fromJSON(output)
    },
    error = function(cond) {
      stop("failed to parse aws secretsmanager output into json, failing")
    }
  )

  jsonlite::fromJSON(jsonOutput$SecretString)
}
