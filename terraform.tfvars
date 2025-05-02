# Environment variables
environment = "dev"

# RabbitMQ configuration
rabbitmq_endpoint = "http://rabbitmq-server-dev:15672"  # Replace with your actual RabbitMQ server URL
rabbitmq_username = "admin"
rabbitmq_password = "Password123!"  # In production, use a secure method to provide this
rabbitmq_insecure = true           # Set to false in production and use proper TLS
rabbitmq_vhost    = "/"

# RabbitMQ exchanges configuration
rabbitmq_exchanges = [
  {
    name        = "audhd.events"
    type        = "topic"
    durable     = true
    auto_delete = false
  },
  {
    name        = "audhd.commands"
    type        = "direct"
    durable     = true
    auto_delete = false
  }
]