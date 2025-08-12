# resource "mongodbatlas_api_key" "project_key" {
#   org_id      = var.atlas_org_id
#   description = "project-specific key for ${var.prefix} lab day"
#   role_names  = ["ORG_READ_ONLY"]
# }

# resource "mongodbatlas_api_key_project_assignment" "new" {
#   project_id = mongodbatlas_project.lab.id
#   api_key_id = mongodbatlas_api_key.project_key.api_key_id
#   roles = ["GROUP_OWNER"]
# }


