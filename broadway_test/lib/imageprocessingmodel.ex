defmodule ImageProcessingModel do
  @moduledoc false

  @enforce_keys [:customer_id, :file_name, :image_type, :path_from, :path_to, :file_name_destination, :destination_type, :status]
  defstruct customer_id: nil,
            file_name: nil,
            image_type: nil,
            path_from: nil,
            path_to: nil,
            file_name_destination: nil,
            destination_type: nil,
            status: :ok


  def create_from_name(model) do
    set_path_from(model)
    <> model.file_name
  end

  def create_resize_name(model) do
    set_path_from(model)
    <> model.customer_id
    <> "_"
    <> String.replace_trailing(model.file_name, "."
    <> model.image_type, "")
    <> "-resized."
    <> model.destination_type
  end

  def create_watermark_name(model) do
    set_path_from(model)
    <> model.customer_id
    <> "_"
    <> String.replace_trailing(model.file_name, "."
    <> model.image_type, "")
    <> "-watermark."
    <> model.destination_type
  end

  def create_destination_name(model) do
    set_path_to(model)
    <> model.customer_id <> "/"
    <> model.customer_id
    <> "_"
    <> model.file_name_destination <> "."
    <> model.destination_type
  end

  defp set_path_from(model) do
     case model.path_from do
       nil -> ""
       _ -> model.path_from
     end
  end

  defp set_path_to(model) do
    case model.path_to do
      nil -> ""
      _ -> model.path_to
    end
  end
end
