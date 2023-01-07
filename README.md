`.aws` Configuration Directory
==============================

Customizations for the [AWS CLI][AWS CLI Command Reference]
([source][aws/aws-cli]).

The following table summarizes the defined
[aliases][Creating and using AWS CLI aliases]:

| Alias                                | Notes                                                                     |
|--------------------------------------|---------------------------------------------------------------------------|
| `rotate-api-keys [ <profile> ... ]`  | Rotate the API keys of the specified profiles (or all if none specified). |
| `get-session-token <profile> <code>` | Obtain a session token for `<profile>` (and update `<profile>-sts`).      |


[aws/aws-cli]: https://github.com/aws/aws-cli/tree/v2
[AWS CLI Command Reference]: https://awscli.amazonaws.com/v2/documentation/api/latest/reference/index.html
[Creating and using AWS CLI aliases]: https://docs.aws.amazon.com/cli/latest/userguide/cli-usage-alias.html
