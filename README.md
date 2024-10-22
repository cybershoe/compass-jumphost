compass-jumphost
================

Ubuntu Jumphosts with MongoDB Compass, mongosh, and atlas-cli installed.

Setup
-----

- Copy tfvars.tf.example to tfvars.tf
- Edit tfvars.tf with tagging data and desired number of replicas
- Add AWS credentials to the environment
- Deploy to AWS:
    - `tofu init`
    - `tofu plan`
    - `tofu apply`

Outputs
-------

Passwords and instance public IPs are output in two ordered lists.

Connecting
----------
Environment setup takes a few minutes. Once xrdp has started, RDP to the
instance IP with the username `ubuntu` and the corresponding password

Notes
-----

- Upon opening MongoDB Compass or Chromium, the user will be prompted to set a
  password for the user's login keychain. The keychain password can be set to
  blank to prevent future prompts.

Teardown
--------
- `tofu destroy`

