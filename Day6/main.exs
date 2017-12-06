defmodule Banks do
  def split(string) do
    string
      |> String.split("\t")
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index
      |> Enum.into(%{}, fn {val,key} -> {key, val} end)
  end

  def inc(x), do: x+1

  def next_bank(banks, current) do
    rem(current + 1, Enum.count(banks))
  end

  def allocate_to(banks, _, 0), do: banks
  def allocate_to(banks, index, remaining_blocks) do
    allocate_to(
      Map.update!(banks, index, &Banks.inc/1),
      next_bank(banks, index),
      remaining_blocks - 1)
  end

  def next_configuration(banks) do
    with {index, blocks} <- Enum.max_by(banks, fn {k, v} -> 1000 * v - k end),
      do: allocate_to(
            Map.put(banks, index, 0),
            next_bank(banks, index),
            blocks)
  end

  def cycles_until_loop(current_config, previous_configs) do
    if MapSet.member?(previous_configs, current_config) do
      MapSet.size(previous_configs)
    else
      cycles_until_loop(
        next_configuration(current_config),
        MapSet.put(previous_configs, current_config))
    end
  end

  def count_cycles(banks) do
    cycles_until_loop(banks, MapSet.new)
  end

  def solve1(input_string) do
    input_string
      |> split
      |> count_cycles
  end

  def cycles_in_loop(current_config, previous_configs) do
    with cycles <- Enum.count(previous_configs),
         last_occurrence <- previous_configs[current_config]
      do:
      (if last_occurrence != nil do
        cycles - last_occurrence
      else
        cycles_in_loop(
          next_configuration(current_config),
          Map.put(previous_configs, current_config, cycles))
      end)
  end

  def loop_length(banks) do
    cycles_in_loop(banks, %{})
  end

  def solve2(input_string) do
    input_string
      |> split
      |> loop_length
  end

  def input, do: File.read! "input.txt"

  def solution1, do: solve1(input())

  def solution2, do: solve2(input())
end