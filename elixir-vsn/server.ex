Code.require_file("elixir-vsn/ruby_client.ex")

defmodule Game.Server do
  @moduledoc """
  House some generic logic that
  1. spawns a generic TCP server on port 1339
  2. listens on that port
  * input from a client <- nc localhost *
  * pass that along to the ruby port
  """
  use GenServer

  require Logger

  alias :gen_tcp, as: TCP

  def start do

    # Start Ruby Process
    {:ok, socket} = start_netcat_process()
    setup_ruby_connection(socket)

    server(socket, [])
  end

  def start_netcat_process() do
    {:ok, left_socket} = :gen_tcp.listen(1339, [:binary])
    # Start accepting connections - * nc - default client
    {:ok, socket} = :gen_tcp.accept(left_socket)

    {:ok, nc_pid} = GenServer.start_link(__MODULE__, {:nc, socket}, [name: :nc_ps, timeout: 60_000])

    :gen_tcp.controlling_process(socket, nc_pid)
    :gen_tcp.controlling_process(left_socket, nc_pid)

    {:ok, socket}
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_info({:tcp, _socket, packet}, state) do
    Logger.info "👂 #{packet}"
    send_ruby_message(packet) |> IO.inspect()
    {:noreply, state}
  end

  def handle_info({:tcp_closed, _socket}, state) do
    :gen_tcp.send(state.server,  "closed 💎 \n")
    {:noreply, state}
  end

  def server(socket, data) do
    #  Start loop
     server(socket, [data])
  end

  defp setup_ruby_connection(server) do
    SmallServer.start_link(server)
  end

  defp send_ruby_message(message) do
    SmallServer.send_message(message)
  end

end

Game.Server.start()
