defmodule ImageProcessingModelTest do

  use ExUnit.Case
#  alias ImageProcessingModel

  setup do
    model_valid_no_path = %ImageProcessingModel{
      file_name: "warthog.jpg",
      customer_id: "FE51EF",
      image_type: "jpg",
      path_from: nil,
      path_to: nil,
      destination_type: "png",
      file_name_destination: "processed-01",
      status: :ok
    }
    model_valid_with_path = %ImageProcessingModel{
      file_name: "warthog.jpg",
      customer_id: "FE51EF",
      image_type: "jpg",
      path_from: "assets/",
      path_to: "assets/",
      destination_type: "png",
      file_name_destination: "processed-01",
      status: :ok
    }

    {:ok, valid: model_valid_no_path, valid_path: model_valid_with_path}
  end

# filename from
  @tag :model
  test "create from name with path", %{valid_path: model} = _context do
    ret = ImageProcessingModel.create_from_name(model)
    assert(ret == "assets/warthog.jpg")
  end

# filename resize
  @tag :model
  test "create resize name with path", %{valid_path: model} = _context do
    ret = ImageProcessingModel.create_resize_name(model)
    assert(ret == "assets/FE51EF_warthog-resized.png")
  end

# filename watermark
  @tag :model
  test "create waternark name without path", %{valid: model} = _context do
    ret = ImageProcessingModel.create_watermark_name(model)
    assert(ret == "FE51EF_warthog-watermark.png")
  end

  @tag :model
  test "create watermark name with path", %{valid_path: model} = _context do
    ret = ImageProcessingModel.create_watermark_name(model)
    assert(ret == "assets/FE51EF_warthog-watermark.png")
  end

# filename destination

  @tag :model
  test "create destination name with path", %{valid_path: model} = _context do
    ret = ImageProcessingModel.create_destination_name(model)
    assert(ret == "assets/FE51EF/FE51EF_processed-01.png")
  end

end
