# Environment variables
environment = "dev"

# RabbitMQ configuration for local Docker container
rabbitmq_endpoint = "http://localhost:15672"  # Default management port for RabbitMQ in Docker
rabbitmq_username = "guest"                  # Default RabbitMQ username
rabbitmq_password = "guest"                  # Default RabbitMQ password
rabbitmq_insecure = true                     # For local development
rabbitmq_vhost    = "/"

# RabbitMQ exchanges configuration
rabbitmq_exchanges = [
  {
    name        = "audhd.input"    # Exchange for other apps to publish to
    type        = "topic"
    durable     = true
    auto_delete = false
  },
  {
    name        = "audhd.output"   # Exchange for AuDHD-LifeCoach to publish to
    type        = "topic"
    durable     = true
    auto_delete = false
  }
]

# RabbitMQ queues configuration
rabbitmq_queues = [
  {
    name        = "audhd.message_queue"  # Queue that AuDHD-LifeCoach reads from
    durable     = true
    auto_delete = false
  }
]

# RabbitMQ bindings configuration
rabbitmq_bindings = [
  {
    source           = "audhd.input"
    destination      = "audhd.message_queue"
    destination_type = "queue"
    routing_key      = "#"  # Subscribe to all messages on this exchange
  }
]