defmodule Imagewatermark do
  @moduledoc false

  use GenStage

  def start_link(state) do
    GenStage.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    {:producer_consumer, state, subscribe_to: [Imageresizer]}
  end

  def handle_events(events, _from, state) do
    IO.inspect(events, label: "Imagewatermark - event")

    case hd(events).status do
       :ok -> create_watermark(events, state)
       :special -> create_watermark(events, state)
       _ -> {:noreply, set_status(events, :error), state}
    end
  end

  defp create_watermark(events, state) do
    event = hd(events)
    str_watermark = ["label:BROADWAY EXAMPLE " <> event.customer_id,
      ImageProcessingModel.create_resize_name(event),
      ImageProcessingModel.create_watermark_name(event)]
    task = Task.async(fn -> System.cmd("composite", str_watermark) end)
    ret = Task.await(task)
    IO.inspect(ret, label: "Imagewatermark - returned from task")
    case ret do
      {"", 0} -> {:noreply, events, state}
      {"", 1} -> {:noreply, set_status(events, :error), state}
    end
  end

  defp set_status(events, status) do
    [%{hd(events) | status: status}]
  end

  defp set_return_tuple(data, status, messagestatus) do

  end
end
