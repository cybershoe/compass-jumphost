variable region {
    description = "Region in which to deploy jumphosts"
    type = string
}

variable availability_zone {
    description = "Availaility zone for public subnet"
    type = string
}

variable tags {
    description = "Tags to add to all created cloud resources"
    type = map(string)
}

variable prefix {
    description = "Prefix for object names"
    type = string
}

variable public_key_openssh {
    description = "Public key for access to AWS resources"
}

