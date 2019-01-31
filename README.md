# Precisely AWS Tools

## Installing

```
install_github("precision-analytics/precisely.aws")
```

## Usage 

### AWS Access Keys

Configuring EC2 instances with an [instance profile][] allows for secure distribution of IAM keys, 
which can then be used to access other AWS resources. These keys are be retrieved from the [instance metadata] service. 

```
precisely.aws.IAM.AssumeRole(roleName)
```

This will fetch and then set the access keys for the provided IAM role, if it has been assigned to the current instance. 
Keys are set in the standard environment variables: 

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

If the instance metadata service is not found (read: the code is not running on an EC2 instance), this method will 
disregard the provided role name and attempt to load keys from the standard AWS CLI credentials file:

- `~/.aws/credentials`

### AWS Secrets Manager

Storing secrets in [AWS Secrets Manager] allows for secure distribution of sensitive information, such as database access credentials. The contents of an existing secret can be retrieved using the [AWS CLI]. 

```
precisely.aws.SecretsManager.getSecretValue(secretName)
```

This will fetch the secret value, parse the output returned by the [AWS CLI], and returned the parsed JSON of the SecretString (i.e. the contents of the secret). 

For example, to retrieve the username and password stored in a secret with the name "example/secret", execute the following code: 

```
library(precisely.aws)
secretContents <- precisely.aws.SecretsManager.getSecretValue("example/secret")
secretContents$username # The username
secretContents$password # The password
```

[instance profile]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html
[instance metadata]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html#instance-metadata-security-credentials
[AWS Secrets Manager]: https://docs.aws.amazon.com/secretsmanager/latest/userguide/manage_create-basic-secret.html
[AWS CLI]: https://docs.aws.amazon.com/cli/latest/reference/
