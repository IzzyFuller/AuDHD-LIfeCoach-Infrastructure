output "rabbitmq_exchanges" {
  description = "List of created RabbitMQ exchanges"
  value       = [for ex in rabbitmq_exchange.exchanges : ex.name]
}

output "rabbitmq_vhost" {
  description = "The RabbitMQ virtual host used"
  value       = var.rabbitmq_vhost
}