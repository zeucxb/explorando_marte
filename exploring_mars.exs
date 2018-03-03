# Importa o código de probe.exs
Code.load_file("probe.exs")

defmodule ExploringMars do
  alias Probe

  # Função que inicia o programa
  def main() do
    [x, y] =
      read_splited_line()
      |> Enum.map(fn value -> String.to_integer(value) end)

    run(read_splited_line(), {x, y})
  end

  # Função recursiva que executa os comandos de cada sonda
  def run(line, {x, y}) do
    if line do
      [probe_x, probe_y, probe_direction] = line

      probe = %Probe{
        x: String.to_integer(probe_x),
        y: String.to_integer(probe_y),
        direction: probe_direction
      }

      # Inicia agente para controlar o status da sonda
      {:ok, agent} = Agent.start_link(fn -> probe end)

      commands = read_all_line() |> String.graphemes()

      Enum.each(commands, fn command ->
        probe = Agent.get(agent, fn probe -> probe end)
        Agent.update(agent, fn _ -> Probe.move(probe, command, {x, y}) end)
      end)

      probe = Agent.get(agent, fn probe -> probe end)

      IO.puts("#{probe.x} #{probe.y} #{probe.direction}")

      Agent.stop(agent)

      run(read_splited_line(), {x, y})
    end
  end

  def read_all_line() do
    line = IO.gets("")

    case line do
      :eof -> false
      value -> String.trim(value)
    end
  end

  def read_splited_line(char \\ " ") do
    line = read_all_line()
    (line && String.split(line, char)) || false
  end
end

# Chama função main e inicia programa
ExploringMars.main()
