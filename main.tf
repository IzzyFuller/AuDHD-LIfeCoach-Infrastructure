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

# Create RabbitMQ queues
resource "rabbitmq_queue" "queues" {
  count = length(var.rabbitmq_queues)
  
  name  = var.rabbitmq_queues[count.index].name
  vhost = var.rabbitmq_vhost
  
  settings {
    durable     = var.rabbitmq_queues[count.index].durable
    auto_delete = var.rabbitmq_queues[count.index].auto_delete
  }
}

# Create RabbitMQ bindings between exchanges and queues
resource "rabbitmq_binding" "bindings" {
  count = length(var.rabbitmq_bindings)
  
  source           = var.rabbitmq_bindings[count.index].source
  destination      = var.rabbitmq_bindings[count.index].destination
  destination_type = var.rabbitmq_bindings[count.index].destination_type
  routing_key      = var.rabbitmq_bindings[count.index].routing_key
  vhost            = var.rabbitmq_vhost
}