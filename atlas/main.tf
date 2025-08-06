# provider "mongodbatlas" {
#   # public_key = var.public_key
#   # private_key  = var.private_key
# }

resource "mongodbatlas_advanced_cluster" "lab_cluster" {
  count = var.replicas
  project_id   = var.project_id
  name         = "${var.prefix}${format("-%03d", count.index+1)}"
  cluster_type = "REPLICASET"
  replication_specs {
    region_configs {
      electable_specs {
        instance_size = "M10"
        node_count    = 3
      }
      provider_name = "AWS"
      priority      = 7
      region_name   = "US_EAST_1"
    }
  }

  tags {
    key   = "owner"
    value = var.owner
  }

  tags {
    key = "pause-from"
    value = var.pause-from
  }

  provisioner "local-exec" {
    command = "atlas clusters sampleData load ${self.name} --projectId ${var.project_id}"
  }
}

resource "mongodbatlas_project_ip_access_list" "local_ip" {
  count = var.replicas
  project_id = var.project_id
  ip_address = var.jumphosts[count.index].ip
  comment    = "ip address for access from jumphost"
}

resource "mongodbatlas_database_user" "test" {
  count              = var.replicas  
  username           = var.jumphosts[count.index].username
  password           = var.jumphosts[count.index].password
  project_id         = var.project_id
  auth_database_name = "admin"

  roles {
    role_name     = "atlasAdmin"
    database_name = "admin"
  }

  labels {
    key   = "owner"
    value = var.owner
  }

  scopes {
    name   = mongodbatlas_advanced_cluster.lab_cluster[count.index].name
    type = "CLUSTER"
  }
}

output connection_strings {
  value = mongodbatlas_advanced_cluster.lab_cluster[*].connection_strings[0].standard_srv
}