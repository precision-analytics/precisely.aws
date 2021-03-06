% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/environment_utilities.R
\name{internal.IsEC2}
\alias{internal.IsEC2}
\title{Verifies a connection to a given URL. Requests the instance identity document from the
EC2 Instance Metadata service by default.}
\usage{

  internal.IsEC2(url = "http://169.254.169.254/latest/dynamic/instance-identity/")
}
\arguments{
\item{url}{A URL to query.}
}
\value{
Returns TRUE if the URL request succeeds, otherwise FALSE
}
\description{
Verifies a connection to a given URL. Requests the instance identity document from the
EC2 Instance Metadata service by default.
}
\seealso{
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/identify_ec2_instances.html
}
\keyword{internal}
