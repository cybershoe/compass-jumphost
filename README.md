compass-jumphost
================

This plan deploys self-contained MongoDB test environments for training and
demos in locked-down environnments, where network or software restrictions may
prevent students from using MongoDB tools directly. For each cluster, a Ubuntu
jumphost is deployed, running guacamole to allow remote access to the desktop
using only a web browser. Each jumphost deploys with:

- MongoDB Compass
- mongosh
- atlas-cli
- Chromium Browser
- VS Codium (open-source build of VS Code)
- A link to an online lab guide
- A text file with the connection string for the corresponding Atlas cluster

> [!CAUTION]
> This repo is intended for short-lived demo environments, and does things
> that would be Very Dumb to do in a production environment. Don't use 
> anything in here as an example of a best practice; check out 
> [the official MongoDB repository](https://github.com/mongodb/terraform-provider-mongodbatlas/tree/master/examples) 
> if you want to learn how to do things the Right Way.

> [!WARNING]
> While I am a MongoDB employee, I'm in pre-sales; neither I nor the code that
> I write should ever be allowed anywhere near a production system.

Prerequisites
-------------

- Terrform or OpenTofu
- atlas-cli
- A DNS domain hosted on Namecheap
- A Namecheap API key, with the IP of the machine running Terraform/OpenTofu whitelisted
- A MongoDB Atlas project
- An API key with Project Owner permissions to the Atlas project
- Programmatic AWS credentials

Setup
-----

- Copy terraform.tfvars.example to tfvars.tf and edit for your deployment:
  #### Required Variables:
  - `owner`, `purpose`, and `expires` tags for Cloud Custodian
  - `prefix` prepended to created resources
  - `dns_domain` name for programmatic DNS record creation
  - `atlas_project_id` Atlas Project ID into which the clusters will be deployed
  #### Optional Variables:
  - `instance_type`, defaults to `t3.small`. `t3.medium` or highter will
    result in a better user experience in exchange for higher cost.
  - `replicas`, defaults to `1`
  - `region`, defaults to `us-east-1`
  - `availability_zone`, defaults to `us-east-1a`
  - `lab_repo`, see [lab repo](#lab-repo) below, defaults to `https://github.com/cybershoe/lab-example.git`
  - `certbot_staging`, defaults to `false`
  - `ssh_source` CIDR block for SSH access to the jumohosts for
  troubleshooting, defaults to the IP of the machine running Terraform as
  reported by ifconfig.me
  - `branding_jar_url` URL to download custom branding for the guacamole login
  screen. See: [Branding Extension](https://github.com/Zer0CoolX/guacamole-customize-loginscreen-extension)
  - `simple_passwords` Generate simple (animal-adjective-number) passwords for
  easier typing in environments where copying and pasting into the jumphost is
  not possible. Defaults to `false`

> [!TIP]
> Set `certbot_staging` to `true` for test deployments in order to avoid
> triggering the Let's Encrypt rate limit of 5 certificates per hostname 
> per week.

> [!CAUTION]
> Using `simple_passwords = true` has obvious security implications. Avoid
> if at all possible.

- Set your environment:
```
export MONGODB_ATLAS_PUBLIC_KEY="my_atlas_public_key"
export MONGODB_ATLAS_PUBLIC_API_KEY="my_atlas_public_key"
export MONGODB_ATLAS_PRIVATE_KEY="my_atlas_private_key"
export MONGODB_ATLAS_PRIVATE_API_KEY="my_atlas_private_key"
export AWS_ACCESS_KEY_ID="MyAwsAccessKeyID"
export AWS_SECRET_ACCESS_KEY="MySuperSecretAndVerySecureAWSSecretAccessKey"
export NAMECHEAP_USER_NAME="MyNamecheapUsername"
export NAMECHEAP_API_USER="MyNamecheapUsername"
export NAMECHEAP_API_KEY="MyNamecheapAPIkey"

```
> [!NOTE]
> Your MongoDB Atlas API environment variables need to be specified twice. The
> Terraform provider and atlas-cli use different environment variable names
> for authentication.


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
> Environment setup can take 10-20 (ish) minutes depending on instance size,
> resource contention, and the phase of the moon. 

Once Guacamole has started, browse to the "url" property of a jumphost, and log in with the supplied credentials.

Lab Repo
--------

The `lab_repo` var points to a git repository containing lab content. It allows you do deploy an online lab guide,
and pre-populate supporting material (python programs, exmaple data, scripts, etc.) into each jumphost. At deploy time, the following steps happen:

1. The repository in `var.lab_repo` is cloned into `/lab-repo` in the jumphost
2. A http server is started on the jumphost on port `:3000` with a root of `/lab-repo/docs`, and this is proxied externally at `https://<jumphost domain name>/docs/`
3. The contents of `/lab-repo/lab/` are copied to `/home/ubuntu/lab`, and chown'd to the `ubuntu` user.

Teardown
--------
- `tofu destroy`

Troubleshooting
---------------

SSH access to the jumphosts is available with the username `ubuntu`, using the
RSA key located at `.ssh/terraform_rsa`. Use the `ssh_source` variable to
override the allowed source IPs for SSH in the NSG.