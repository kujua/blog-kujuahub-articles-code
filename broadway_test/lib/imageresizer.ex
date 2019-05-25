defmodule Imageresizer do
  @moduledoc false

  use GenStage
  alias ImageProcessingModel

  def process(data) do
    IO.inspect(data, label: "Imageresizer - process data")
    success = GenStage.call(__MODULE__, {:process, data}, 3000)
    IO.inspect(success, label: "return genstage call - success")
    case success do
      :ok -> data
      _ -> data = set_status(data, :error)
    end
  end

  def start_link(state) do
    GenStage.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    {:producer, state}
  end

  def handle_call({:process, event}, _from, state) do

    IO.inspect(event, label: "Imageresizer - call - event data")

    task = Task.async(fn -> runmagick(
            ImageProcessingModel.create_from_name(event),
            ImageProcessingModel.create_resize_name(event))  end)
    {_,ret} = Task.await(task)

    IO.inspect(ret, label: "Imageresizer - returned from task")

    case ret do
      0 -> {:reply, :ok, [event], state}
      _ -> {:reply, :error, [%{event | status: :error}], state}
    end
  end

  def handle_demand(_demand, state) do
    {:noreply, [], state}
  end

  defp runmagick(from, to) do
     System.cmd("./assets/resize.sh", [from, to])
  end

  defp set_status(model, status) do
    %{model | status: status}
  end
end