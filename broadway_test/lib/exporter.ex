defmodule Exporter do
  @moduledoc false

  use GenStage

  def start_link(state) do
    GenStage.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_state) do
    {:consumer, 0, subscribe_to: [Imagewatermark]}
  end

  def handle_events(events, _from, state) do
    # process
    IO.inspect(events, label: "Exporter - event handler")
    case hd(events).status do
      :ok -> export_processed_file(events, state)
      :special -> export_processed_file(events, state)
      _ -> {:noreply, [], state}
    end
  end

  defp export_processed_file(events, state) do
    mkdir_arguments = [hd(events).path_to <> hd(events).customer_id]
    task = Task.async(fn -> System.cmd("mkdir", mkdir_arguments) end)
    ret = Task.await(task)
    IO.inspect(ret, label: "Exporter - returned from task mkdir")
    move_arguments = ["-f",
              ImageProcessingModel.create_watermark_name(hd(events)),
              ImageProcessingModel.create_destination_name(hd(events))]
    IO.inspect(move_arguments, label: "Exporter - task arguments")
    task = Task.async(fn -> System.cmd("mv", move_arguments) end)
    ret = Task.await(task)
    IO.inspect(ret, label: "Exporter - returned from task mv")
    task = Task.async(fn -> System.cmd("rm", [ImageProcessingModel.create_resize_name(hd(events))]) end)
    ret = Task.await(task)
    IO.inspect(ret, label: "Exporter - returned from task mv")
    {:noreply, [], state}
  end
end
