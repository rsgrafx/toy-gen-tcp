defmodule SmallServer do
  use GenServer
  require Logger
  alias :gen_tcp, as: TCP

  def start_link(server) do
    {:ok, socket} = TCP.connect({127, 0, 0, 1}, 1337, [:binary, {:active, true}, {:packet, 0}])
    {:ok, pid} = GenServer.start_link(__MODULE__, %{server: server, client: socket}, [name: :ruby_client, timeout: 60_000])
    :gen_tcp.controlling_process(socket, pid)
  end

  # @deprecated "Use send_msg/2 instead"
  def send_message(message) do
    pid = Process.whereis(:ruby_client)
    msg = String.trim(message)
    GenServer.call(pid, {:message, msg}, 30_000)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:message, command}, _, state) do
    socket = state.client
    # server = state.server

    command = String.trim_trailing(command)

    TCP.send(socket, command)

    send(self, :recv)

    {:reply, {:ok, :sent}, state}
  end

  @impl true
  def handle_info({:ok, received_data}, state) do
    :gen_tcp.send(state.server,  "#{received_data} 💎 💎 \n")
    {:noreply, state}
  end

  def handle_info({:error, reason}, state) do
    :gen_tcp.send(state.server,  "COULD NOT PROCESS * * #{reason} * * ")
    {:noreply, state}
  end

  def handle_info({:tcp, _socket, packet}, state) do
    IO.inspect(packet)
    :gen_tcp.send(state.server,  "#{packet} 💎 \n")
    {:noreply, state}
  end

  def handle_info({:tcp_closed, _socket}, state) do
    :gen_tcp.send(state.server,  "closed 💎 \n")
    {:noreply, state}
  end

  def handle_info({:tcp_error, socket, reason}, state) do
    IO.inspect socket, label: "connection closed due to #{reason}"
    {:noreply, state}
  end

  def handle_info(:recv, state) do
    send(self(), :gen_tcp.recv(state.client, 0))
    {:noreply, state}
  end

  def handle_info(what, state) do
    IO.inspect(what, label: "Anything received?")
    {:noreply, state}
  end

  # @impl true
end
