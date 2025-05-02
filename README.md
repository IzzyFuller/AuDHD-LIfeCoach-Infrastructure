# AuDHD LifeCoach Infrastructure

This project will use a Infrstructure as code tool such as TerraForm to manage all the external infrastructure dependencies the larger AuDHD LifeCoach requires.

At this time that includes a RabbitMQ server and the exchanges required by the various components of the application for consumption and publishing of messages. In the future we will need to manage AuthN/AuthZ configuration, and possibly cloud storage, etc.
