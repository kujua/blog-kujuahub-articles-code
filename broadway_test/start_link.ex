def start_link(_opts) do
  Broadway.start_link(__MODULE__,
    name: RabbitBroadway, # Define the registered name of our Broadway server
    context: %{}, # We could pass a user defined structure
    producers: [
      default: [ # The name of our producer is default
        module: {BroadwayRabbitMQ.Producer, # We use the predefined RabbitMQ producer
          queue: "images", # The queue has the name images
          qos: [
            prefetch_count: 10, # RabbitMQ specific:
                    #defines how many messages are sent at the same time
          ]
        },
        stages: 2
      ]
    ],
    processors: [
      default: [ # The name of our processor is default
        stages: 50
      ]
    ],
    batchers: [
      default: [ # The name of our first batcher is default
        batch_size: 10,
        batch_timeout: 1500,
        stages: 5
      ],
      special: [ # The name of our first batcher is special
        stages: 1,
        batch_size: 5,
        batch_timeout: 1500,
      ]
    ]
  )
end