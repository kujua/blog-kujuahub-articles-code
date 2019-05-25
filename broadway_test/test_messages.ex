@tag :broadway
test "broadway pipeline integration test" do
  ref = Broadway.test_messages(RabbitBroadway, ["S3R556,warthog.jpg,jpg,assets/,assets/,processed-01,png"])
  # assert_receive {:ack, ^ref, successful, failed}
  Process.sleep(1000)
  IO.inspect(ref, label: "Reference")
end
