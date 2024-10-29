compass-jumphost
================

Ubuntu Jumphosts with Apache Guacamole installed for in-browser access to 
MongoDB Compass, mongosh, and atlas-cli in locked-down environments.

Setup
-----

- Copy terraform.tfvars.example to tfvars.tf and edit for your deployment:
  #### Required Variables:
  - `owner`, `purpose`, and `expires` tags for Cloud Custodian
  - `prefix` prepended to created resources
  - `dns_domain` name for programmatic DNS record creation
  #### Optional Variables:
  - `instance_type`, defaults to `t3.small`. `t3.medium` or highter will
    result in a better user experience in exchange for higher cost.
  - `replicas`, defaults to `1`
  - `region`, defaults to `us-east-1`
  - `availability_zone`, defaults to `us-east-1a`
  - `lab_guide_url`, defaults to a placeholder PDF



> [!TIP]
> Set `certbot_staging` to `true` for test deployments in order to avoid
> triggering the Let's Encrypt rate limit of 5 certificates per hostname 
> per week.

- Set your environment:
```
export AWS_ACCESS_KEY_ID="MyAwsAccessKeyID"
export AWS_SECRET_ACCESS_KEY="MySuperSecretAndVerySecureAWSSecretAccessKey"
export NAMECHEAP_USER_NAME="MyNamecheapUsername"
export NAMECHEAP_API_USER="MyNamecheapUsername"
export NAMECHEAP_API_KEY="MyNamecheapAPIkey"

```

> [!IMPORTANT]
> Remember to add the egress IP of your terraform/tofu runner to the Namecheap API IP whitelist

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
> [!NOTE]
> Environment setup can take 5-10 (ish) depending on instance size,
> resource contention, and the phase of the moon. 

Once Guacamole has started, browse to the "url" property of a jumphost, and log in with the supplied credentials.

Teardown
--------
- `tofu destroy`

Troubleshooting
---------------

SSH access to the jumphosts is available with the username `ubuntu`, using the
RSA key located at `.ssh/terraform_rsa`