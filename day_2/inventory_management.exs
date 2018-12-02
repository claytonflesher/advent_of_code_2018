defmodule AdventOfCode.InventoryManagement do
  def calculate_checksum(ids) do
    do_calculate_checksum(ids, %{twice: 0, thrice: 0})
    |> Map.values
    |> Enum.reduce(fn x, acc -> acc * x end)
  end

  def find_prototypes(ids) do
    prototypes = ids
    |> Enum.filter(fn (id) -> has_partner?(ids, id) end)

    standardize(prototypes)
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

  defp has_partner?(ids, id) do
    ids
    |> Enum.any?(fn (id_a) -> count_differences(id_a, id) == 1 end)
  end

  defp count_differences(id_a, id_b) do
    Enum.zip(id_a, id_b)
    |> Enum.count(fn {a, b} -> a != b end)
  end

  defp standardize(ids)do
    {filtered, _} = ids
    |> Enum.zip
    |> Enum.filter(fn (tuple) -> is_same?(tuple) end)
    |> Enum.unzip

    Enum.join(filtered)
  end

  defp is_same?(tuple) do
    size = tuple
    |> Tuple.to_list
    |> Enum.uniq
    |> Enum.join
    |> String.length

    size == 1
  end

end

{:ok, file} = File.read("input.txt")
file
|> String.split("\n")
|> List.delete_at(-1)
|> Enum.map(&(String.graphemes(&1)))
#|> AdventOfCode.InventoryManagement.calculate_checksum
|> AdventOfCode.InventoryManagement.find_prototypes
|> IO.inspect
