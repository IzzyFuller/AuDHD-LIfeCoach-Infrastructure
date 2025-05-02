output "rabbitmq_exchanges" {
  description = "List of created RabbitMQ exchanges"
  value       = [for ex in rabbitmq_exchange.exchanges : ex.name]
}

output "rabbitmq_queues" {
  description = "List of created RabbitMQ queues"
  value       = [for q in rabbitmq_queue.queues : q.name]
}

output "rabbitmq_bindings" {
  description = "List of created RabbitMQ bindings"
  value       = [for b in rabbitmq_binding.bindings : "${b.source} -> ${b.destination} (${b.routing_key})"]
}

output "rabbitmq_vhost" {
  description = "The RabbitMQ virtual host used"
  value       = var.rabbitmq_vhost
}