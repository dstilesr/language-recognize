variable "language_recognize_bucket" {
  type        = string
  description = "Bucket where project data (i.e. models and dataset) are stored."
}

variable "project" {
  type        = string
  description = "Name of the project resources are associated to."
  default     = "language-recognize"
}

variable "img_tag" {
  type        = string
  description = "Tag of docker image to pull from ECR."
  default     = "latest"
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet where the service will run."
}
