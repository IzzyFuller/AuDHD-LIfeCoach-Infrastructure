variable "environment" {
  description = "The deployment environment (dev, prod, etc.)"
  type        = string
}

variable "rabbitmq_endpoint" {
  description = "The HTTP endpoint of the RabbitMQ management interface"
  type        = string
}

variable "rabbitmq_username" {
  description = "Username for RabbitMQ admin access"
  type        = string
  sensitive   = true
}

variable "rabbitmq_password" {
  description = "Password for RabbitMQ admin access"
  type        = string
  sensitive   = true
}

variable "rabbitmq_insecure" {
  description = "Whether to skip TLS verification when connecting to RabbitMQ"
  type        = bool
  default     = false
}

variable "rabbitmq_vhost" {
  description = "The RabbitMQ virtual host to use"
  type        = string
  default     = "/"
}

variable "rabbitmq_exchanges" {
  description = "List of RabbitMQ exchanges to create"
  type = list(object({
    name        = string
    type        = string
    durable     = bool
    auto_delete = bool
  }))
  default = []
}

variable "rabbitmq_queues" {
  description = "List of RabbitMQ queues to create"
  type = list(object({
    name        = string
    durable     = bool
    auto_delete = bool
  }))
  default = []
}

variable "rabbitmq_bindings" {
  description = "List of RabbitMQ bindings between exchanges and queues"
  type = list(object({
    source           = string
    destination      = string
    destination_type = string
    routing_key      = string
  }))
  default = []
}