compass-jumphost
================

Ubuntu Jumphosts with Apache Guacamole installed for in-browser access to 
MongoDB Compass, mongosh, and atlas-cli in locked-down environments.

Setup
-----

- Copy terraform.tfvars.example to tfvars.tf and edit for your deployment:
  - `owner`, `purpose`, and `expires` tags for Cloud Custodian
  - `prefix` prepended to created resources
  - `instance_type` and desired number of `replicas`
  - `ddns_domain` name for dynamic DNS updates

- Set your environment:
```
export AWS_ACCESS_KEY_ID="MyAwsAccessKeyID"
export AWS_SECRET_ACCESS_KEY="MySuperSecretAndVerySecureAWSSecretAccessKey"
export TF_VAR_ddns_password="MyDynamicDnsUpdatePassword"
```

- Deploy to AWS:
```
tofu init
tofu plan
tofu apply
```

Outputs
-------

**credentials:** List of HCL objects with connection details and credentials for each jumphost. e.g.:
```
credentials = [
  {
    "ip" = "1.1.1.1"
    "password" = "S00perSekrit"
    "url" = "https://jumphost001.example.com/"
    "username" = "user001"
  },
  {
    "ip" = "1.1.1.2"
    "password" = "sw0rdF1$h"
    "url" = "https://jumphost002.example.com/"
    "username" = "user002"
  },
]
```

Connecting
----------
Environment setup takes a few minutes. Once Guacamole has started, browse to the
"url" property of a jumphost, and log in with the supplied credentials.

Teardown
--------
- `tofu destroy`

