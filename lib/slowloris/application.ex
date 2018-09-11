defmodule SlowLoris.Application do
  use Application

  def start(_type, _args) do
    children = 1..1000 |> Enum.map(fn number -> %{start: {SlowLoris, :start_link, ['localhost', 8081, '/', number]}, id: String.to_atom("worker_#{number}")} end)
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
