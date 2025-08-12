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