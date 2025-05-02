terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    rabbitmq = {
      source  = "cyrilgdn/rabbitmq"
      version = "~> 1.8.0"
    }
  }
}

provider "rabbitmq" {
  endpoint = var.rabbitmq_endpoint
  username = var.rabbitmq_username
  password = var.rabbitmq_password
  
  # In production you might want to set this to false and use proper TLS
  insecure = var.rabbitmq_insecure
}

# Create RabbitMQ exchanges
resource "rabbitmq_exchange" "exchanges" {
  count = length(var.rabbitmq_exchanges)
  
  name  = var.rabbitmq_exchanges[count.index].name
  vhost = var.rabbitmq_vhost
  
  settings {
    type        = var.rabbitmq_exchanges[count.index].type
    durable     = var.rabbitmq_exchanges[count.index].durable
    auto_delete = var.rabbitmq_exchanges[count.index].auto_delete
  }
}