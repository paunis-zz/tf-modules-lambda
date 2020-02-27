variable "role_name" {
  type = string
}

variable "lambda_name" {
  type = string
}

variable "lambda_filename" {
  type = string
}

variable "lambda_handler" {
  type = string
}

variable "lambda_runtime" {
  type = string
}

variable "lambda_variables" {
  type    = map(string)
  default = {}
}

variable "lambda_timeout" {
  type    = number
  default = 60
}

variable "layer_filename" {
  type = string
}

variable "layer_name" {
  type = string
}

variable "layer_runtimes" {
  type = list(string)
}

variable "permission_action" {
}

variable "permission_principal" {
}

variable "logs_retention" {
  type    = number
  default = 30
}

variable "policy_name" {
  type = string
}

variable "policies" {
  type = list(object({
    Action   = list(string)
    Resource = list(string)
    Effect   = string
  }))
  default = []
}

variable "region" {}

variable "profile" {}
