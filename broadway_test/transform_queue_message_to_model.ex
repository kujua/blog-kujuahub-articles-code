def transform_queue_message_to_model(message, _opts) do
  model = create_model(message)
  %Message{
    data: validate_model(model),
    acknowledger: {BroadwayTest, :ack_imageprocessor, :ack_data}
  }
end

defp validate_model(model) do
  model
end

defp create_model(message) do
  list = String.split(message, ",")
  model = %ImageProcessingModel{
    customer_id: Enum.at(list, 0),
    file_name: Enum.at(list, 1),
    image_type: Enum.at(list, 2),
    path_from: Enum.at(list, 3),
    path_to: Enum.at(list, 4),
    file_name_destination: Enum.at(list, 5),
    destination_type: Enum.at(list, 6),
    status: :ok
  }
  model = if String.starts_with?(model.customer_id, "S") do
    %{model | status: :special}
  else
    model
  end
  model
end