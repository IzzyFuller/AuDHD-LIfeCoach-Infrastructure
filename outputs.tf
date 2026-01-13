output "rabbitmq_exchanges" {
  description = "List of created RabbitMQ exchanges with details"
  value = [for ex in rabbitmq_exchange.exchanges : {
    name        = ex.name
    type        = ex.settings[0].type
    durable     = ex.settings[0].durable
    auto_delete = ex.settings[0].auto_delete
  }]
}

output "rabbitmq_queues" {
  description = "List of created RabbitMQ queues with details"
  value = [for q in rabbitmq_queue.queues : {
    name        = q.name
    durable     = q.settings[0].durable
    auto_delete = q.settings[0].auto_delete
  }]
}

output "rabbitmq_bindings" {
  description = "List of created RabbitMQ bindings with details"
  value = [for b in rabbitmq_binding.bindings : {
    source           = b.source
    destination      = b.destination
    destination_type = b.destination_type
    routing_key      = b.routing_key
  }]
}

output "rabbitmq_connection" {
  description = "RabbitMQ connection details for components"
  value = {
    endpoint = var.rabbitmq_endpoint
    vhost    = var.rabbitmq_vhost
    # Note: Credentials should be provided via environment variables, not in config
  }
}

output "topology_config" {
  description = "Complete topology configuration for component consumption"
  value = {
    exchanges = [for ex in rabbitmq_exchange.exchanges : {
      name        = ex.name
      type        = ex.settings[0].type
      durable     = ex.settings[0].durable
      auto_delete = ex.settings[0].auto_delete
    }]
    queues = [for q in rabbitmq_queue.queues : {
      name        = q.name
      durable     = q.settings[0].durable
      auto_delete = q.settings[0].auto_delete
    }]
    bindings = [for b in rabbitmq_binding.bindings : {
      source           = b.source
      destination      = b.destination
      destination_type = b.destination_type
      routing_key      = b.routing_key
    }]
    connection = {
      endpoint = var.rabbitmq_endpoint
      vhost    = var.rabbitmq_vhost
    }
  }
}