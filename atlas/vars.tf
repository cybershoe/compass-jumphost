# variable public_key {
#   type        = string
#   description = "MongoDB Atlas Public Key"
# }

# variable private_key {
#   type        = string
#   description = "MongoDB Atlas Private Key"
#   sensitive   = true
# }

# variable project_id {
#   type        = string
#   description = "MongoDB Atlas Project ID"
# }

variable atlas_org_id {
  type        = string
  description = "MongoDB Atlas Organization ID"
}

variable prefix {
  type        = string
  description = "Prefix for MongoDB Atlas cluster names"
}

variable owner {
  type        = string
  description = "Cluster owner tag"
}

variable replicas {
  type       = number
  description = "Number of clusters to deploy"
}

# variable jumphost_ips {
#   type        = list(string)
#   description = "List of jumphost IPs to allow access to the MongoDB Atlas cluster"
# }

# variable passwords {
#   type        = list(string)
#   description = "List of passwords for the atlas users"
# }

variable jumphosts {
  type          = list(object({
    username      = string
    password      = string
    ip            = string
    url           = string
  }))
  description = "Map of jumphost instance IDs to their passwords"
}

variable "pause-from" {
  description = "Value of the pause-from tag on all created cloud resources"
  type        = string
}