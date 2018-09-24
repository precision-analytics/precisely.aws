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



[instance profile]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html
[instance metadata]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html#instance-metadata-security-credentials