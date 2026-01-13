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
    name        = "core.messages"  # Core component reads incoming conversations
    durable     = true
    auto_delete = false
  },
  {
    name        = "persistence.audhd_input"  # PersistenceFurthers audits incoming conversations
    durable     = true
    auto_delete = false
  },
  {
    name        = "persistence.audhd_output"  # PersistenceFurthers audits outgoing actions
    durable     = true
    auto_delete = false
  }
]

# RabbitMQ bindings configuration
rabbitmq_bindings = [
  {
    source           = "audhd.input"
    destination      = "core.messages"
    destination_type = "queue"
    routing_key      = "#"  # Core subscribes to all input messages
  },
  {
    source           = "audhd.input"
    destination      = "persistence.audhd_input"
    destination_type = "queue"
    routing_key      = "#"  # PersistenceFurthers audits all input messages
  },
  {
    source           = "audhd.output"
    destination      = "persistence.audhd_output"
    destination_type = "queue"
    routing_key      = "#"  # PersistenceFurthers audits all output messages
  }
]