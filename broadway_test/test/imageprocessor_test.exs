defmodule ImageprocessorTest do

  use ExUnit.Case

  @tag :dummy
  test "dummy" do
    assert true
  end

  @tag :gen_stage
  test "gen_stage pipeline integration test" do
    Imageresizer.process(%{file_name: "warthog.jpg",
                            customer_id: "FE51EF",
                            image_type: "jpg",
                            destination_type: "png",
                            file_name_destination: "processed-01",
                            path_from: "assets/",
                            path_to: "assets/",
                            status: :ok})
    Process.sleep(500)
  end

  @tag :broadway
  test "broadway pipeline integration test" do
    ref = Broadway.test_messages(RabbitBroadway, ["S3R556,warthog.jpg,jpg,assets/,assets/,processed-01,png"])
    Process.sleep(1000)
    IO.inspect(ref, label: "Reference")
  end
end