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