defmodule Checksum do
  def split(string) do
    string
      |> String.split("\n")
      |> Enum.filter(fn (line) -> String.length(line) > 0 end)
      |> Enum.map(fn (line) ->
                    line
                      |> String.split("\t")
                      |> Enum.map(&String.to_integer/1)
                  end)
  end

  def span(list) do
    Enum.max(list) - Enum.min(list)
  end

  def solve1(input_string) do
    input_string
      |> split
      |> Enum.map(&Checksum.span/1)
      |> Enum.sum
  end

  def divides?(divisor, dividend), do: rem(dividend, divisor) == 0

  def find_even_divisor(dividend, candidates) do
    candidates
      |> Enum.find(&Checksum.divides?(&1, dividend))
  end

  def find_even_division_pair([largest | smallers]) do
    case find_even_divisor(largest, smallers) do
      nil -> find_even_division_pair(smallers)
      divisor -> {largest, divisor}
    end
  end

  def find_integer_quotient(list_of_integers) do
    list_of_integers
      |> Enum.sort()
      |> Enum.reverse()
      |> find_even_division_pair
      |> (fn ({dividend, divisor}) -> div(dividend, divisor) end).()
  end

  def solve2(input_string) do
    input_string
      |> split
      |> Enum.map(&Checksum.find_integer_quotient/1)
      |> Enum.sum
  end

  def input, do: File.read! "input.txt"

  def solution1, do: solve1(input())

  def solution2, do: solve2(input())
end