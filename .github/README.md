`.aws` Configuration Directory
==============================

Customizations for the [AWS CLI][AWS CLI Command Reference]
([source][aws/aws-cli]).

The following table summarizes the defined
[aliases][Creating and using AWS CLI aliases]:

| Alias                                                  | Notes                                                               |
|--------------------------------------------------------|---------------------------------------------------------------------|
| `rotate-access-keys [ <profile> ... ]`                 | Rotate the access keys of the specified profiles (default: all).    |
| `get-session-profile <profile> <code>`                 | Obtain a session token for `<profile>` and update `<profile>-mfa`.  |
| `remove-ssh-known-hosts [ <profile> ... ]`             | Remove entries from `${HOME}/.ssh/known_hosts`.                     |
| `backup retain-latest-recovery-points-forever <vault>` | Remove expiration from latest recovery points in `<vault>`.         |
| `ec2 active-regions`                                   | List all active regions                                             |
| `ec2 private-ip-addresses`                             | Get the private addresses of all EC2 instances (all active regions) |

Note: The `get-session-profile` requires the `mfa_serial` of the MFA device
recorded in the `~/.aws/config`:

```bash
$ aws --profile=PROFILE configure set mfa_serial arn:aws:iam::999999999999:mfa/USER
```

A session token may be generated and used with:

```bash
$ aws get-session-profile PROFILE 916683
$ eval $(aws --profile=PROFILE-session configure export-credentials --format=env)
```


[aws/aws-cli]: https://github.com/aws/aws-cli/tree/v2
[AWS CLI Command Reference]: https://awscli.amazonaws.com/v2/documentation/api/latest/reference/index.html
[Creating and using AWS CLI aliases]: https://docs.aws.amazon.com/cli/latest/userguide/cli-usage-alias.html
