def handle_message(processor, message, context) do
  # create a Broadway message from the csv input
  updatedmessage = Transformer.transform_queue_message_to_model(message.data, [])
                   |> Message.update_data(&process_data/1)

  # check the returned message status if we should push it to a certain batcher
  case updatedmessage.data.status do
    :ok -> updatedmessage # this will use the batcher with the name default

    # this will use the batcher with the name special
    :special -> Message.put_batcher(updatedmessage, :special)

    # the status says the message processing failed
    _ -> Message.failed(updatedmessage, "image processing failed")
  end

  defp process_data(data) do
    Imageresizer.process(data) # pass the message to the GenStage server
  end
end