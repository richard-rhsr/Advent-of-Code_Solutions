defmodule Maze do
  def split(string) do
    string
      |> String.split("\n")
      |> Enum.filter(fn (line) -> String.length(line) > 0 end)
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index
      |> Enum.into(%{}, fn {val,key} -> {key, val} end)
  end

  def process(instructions, current, moves, update_fn) do
    if Map.get(instructions, current) == nil do
      moves
    else
      with updated_instructions <- Map.update!(instructions, current, update_fn),
           offset <- Map.get(instructions, current),
        do: process(updated_instructions, current+offset, moves+1, update_fn)
    end
  end

  def inc(x), do: x+1

  def solve1(input_string) do
    input_string
      |> split
      |> process(0, 0, &Maze.inc/1)
  end

  def conditional_inc(x) do
    if x >= 3 do
      x-1
    else
      x+1
    end
  end

  def solve2(input_string) do
    input_string
      |> split
      |> process(0, 0, &Maze.conditional_inc/1)
  end

  def input, do: File.read! "input.txt"

  def solution1, do: solve1(input())

  def solution2, do: solve2(input())
end