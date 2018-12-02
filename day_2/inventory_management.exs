defmodule AdventOfCode.InventoryManagement do
  def calculate_checksum(ids) do
    do_calculate_checksum(ids, %{twice: 0, thrice: 0})
    |> Map.values
    |> Enum.reduce(fn x, acc -> acc * x end)
  end

  defp do_calculate_checksum([head | tail], state) do
    new_state = update_state(state, head)
    do_calculate_checksum(tail, new_state)
  end

  defp do_calculate_checksum([], state) do
    state
  end

  defp update_state(state, id) do
    state
    |> update_for_pairs(id)
    |> update_for_trios(id)
  end

  defp update_for_pairs(state, id) do
    case has_pair?(id) do
      true ->
        Map.update!(state, :twice, &(&1 + 1))
      false ->
        state
    end
  end

  defp update_for_trios(state, id) do
    case has_trio?(id) do
      true ->
        Map.update!(state, :thrice, &(&1 + 1))
      false ->
        state
    end
  end

  defp has_pair?(id) do
    Enum.uniq(id)
    |> Enum.any?(fn item -> Enum.count(id, &(&1 == item)) == 2 end)
  end

  defp has_trio?(id) do
    Enum.uniq(id)
    |> Enum.any?(fn item -> Enum.count(id, &(&1 == item)) == 3 end)
  end
end

{:ok, file} = File.read("input.txt")
file
|> String.split("\n")
|> List.delete_at(-1)
|> Enum.map(&(String.graphemes(&1)))
|> AdventOfCode.InventoryManagement.calculate_checksum
|> IO.inspect
