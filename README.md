`.aws` Configuration Directory
==============================

Customizations for the [AWS CLI][AWS CLI Command Reference]
([source][aws/aws-cli]).

The following table summarizes the defined
[aliases][Creating and using AWS CLI aliases]:

| Alias                                      | Notes                                                              |
|--------------------------------------------|--------------------------------------------------------------------|
| `rotate-access-keys [ <profile> ... ]`     | Rotate the access keys of the specified profiles (default: all).   |
| `get-mfa-profile <profile> <code>`         | Obtain a session token for `<profile>` and update `<profile>-mfa`. |
| `remove-ssh-known-hosts [ <profile> ... ]` | Remove entries from `${HOME}/.ssh/known_hosts`.                    |

Note: The `get-mfa-profile` requires the `mfa_serial` of the MFA device
recorded in the `~/.aws/config`:

```bash
$ aws --profile=PROFILE configure set mfa_serial arn:aws:iam::999999999999:mfa/USER
```

A session token may be generated and used with:

```bash
$ aws get-mfa-profile PROFILE 916683
$ eval $(aws --profile=PROFILE-mfa configure export-credentials --format=env)
```


[aws/aws-cli]: https://github.com/aws/aws-cli/tree/v2
[AWS CLI Command Reference]: https://awscli.amazonaws.com/v2/documentation/api/latest/reference/index.html
[Creating and using AWS CLI aliases]: https://docs.aws.amazon.com/cli/latest/userguide/cli-usage-alias.html
