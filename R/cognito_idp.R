library(jsonlite)

#' Retrieves a list of the usernames of the users in a given Cognito group.
#'
#' @param userPoolId The Cognito User Pool ID.
#' @param groupName The name of the Cognito group.
#'
#' @return A character vector of the usernames of the users in the group.
precisely.aws.CognitoIdp.getUsersInGroup <- function(userPoolId, groupName) {
  output <- tryCatch(
    {
      args <- c("cognito-idp",
                "list-users-in-group",
                "--user-pool-id", userPoolId,
                "--group-name", groupName)
      system2("aws", args = args, stdout = TRUE, stderr = "./error.log")
    },
    error = function (cond) {
      stop("aws command not found, failing")
    },
    warning = function (cond) {
      error_msg <- readr::read_lines("./error.log", skip_empty_rows = TRUE)
      stop(error_msg)
    }
  )

  jsonOutput <- tryCatch(
    {
      fromJSON(output)
    },
    error = function(cond) {
      stop("failed to parse aws cognito-idp output into json, failing")
    }
  )

  jsonOutput$Users$Username
}
