defmodule AdventOfCode.Frequency do
  def calculate_frequency(list) do
    change_frequency(list, 0)
  end

  def calculate_first_duplicate(list) do
    calculate_first_duplicate(list, %{0 => 1}, 0, list)
  end

  defp change_frequency([offset | tail], state) do
    new_state = state + offset
    change_frequency(tail, new_state)
  end

  defp change_frequency([], state) do
    state
  end

  defp calculate_first_duplicate([head | tail], previous, frequency, list) do
    new_state = frequency + head
    case Map.has_key?(previous, new_state) do
      true ->
        new_state
      false ->
        calculate_first_duplicate(
          tail,
          Map.put(previous, new_state, 1),
          new_state,
          list
        )
    end
  end

  defp calculate_first_duplicate([], previous, frequency, list) do
    calculate_first_duplicate(list, previous, frequency, list)
  end
end

{:ok, file} = File.read("input.txt")
file
|> String.split("\n")
|> List.delete_at(-1)
|> Enum.map(fn (item) -> String.to_integer(item) end)
#|> AdventOfCode.Frequency.calculate_frequency
|> AdventOfCode.Frequency.calculate_first_duplicate
|> IO.inspect


