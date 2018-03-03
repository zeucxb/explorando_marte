defmodule Probe do
  alias Probe
  defstruct direction: "", x: 0, y: 0

  @directions ["N", "E", "S", "W"]

  defp get_direction_index(probe),
    do: Enum.find_index(@directions, fn value -> value == probe.direction end)

  defp get_direction(probe, command) do
    preobe_direction_index = get_direction_index(probe)
    last_direction_index = length(@directions) - 1

    case command do
      "L" ->
        (preobe_direction_index > 0 && Enum.fetch(@directions, preobe_direction_index - 1)) ||
          Enum.fetch(@directions, last_direction_index)

      "R" ->
        (preobe_direction_index < last_direction_index &&
           Enum.fetch(@directions, preobe_direction_index + 1)) || Enum.fetch(@directions, 0)
    end
  end

  def move(probe, command, {x, y}) do
    case command do
      "L" ->
        {:ok, probe_direction} = get_direction(probe, command)
        %Probe{probe | direction: probe_direction}

      "R" ->
        {:ok, probe_direction} = get_direction(probe, command)
        %Probe{probe | direction: probe_direction}

      "M" ->
        cond do
          probe.direction == "N" && probe.y < y ->
            %Probe{probe | y: probe.y + 1}

          probe.direction == "E" && probe.x < x ->
            %Probe{probe | x: probe.x + 1}

          probe.direction == "W" && probe.x > 0 ->
            %Probe{probe | x: probe.x - 1}

          probe.direction == "S" && probe.y > 0 ->
            %Probe{probe | y: probe.y - 1}

          true ->
            probe
        end
    end
  end
end
