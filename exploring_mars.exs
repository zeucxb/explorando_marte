Code.load_file("probe.exs")

defmodule ExploringMars do
  alias Probe

  def main() do
    [x, y] =
      read_splited_line()
      |> Enum.map(fn value -> String.to_integer(value) end)

    [probe_x, probe_y, probe_direction] = read_splited_line()

    probe = %Probe{x: probe_x, y: probe_y, direction: probe_direction}

    {:ok, agent} = Agent.start_link(fn -> probe end)

    commands = read_all_line() |> String.graphemes()

    Enum.each(commands, fn command ->
      probe = Agent.get(agent, fn probe -> probe end) |> IO.inspect()
      Agent.update(agent, fn _ -> Probe.move(probe, command) end)
    end)

    Agent.get(agent, fn probe -> probe end)
  end

  def read_all_line() do
    IO.gets("")
    |> String.trim()
  end

  def read_splited_line(char \\ " ") do
    read_all_line()
    |> String.split(char)
  end
end

ExploringMars.main()
