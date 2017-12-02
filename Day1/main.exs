defmodule Rotate do
  def left_by1([]), do: []
  def left_by1([head | tail]), do: tail ++ [head]

  def left([], _), do: []
  def left(list, 0), do: list
  def left(list, n), do: left(left_by1(list), n-1)

  def left_by_half(list), do: Rotate.left(list, (Enum.count(list) / 2)
                                                  |> Float.floor
                                                  |> round)
end

defmodule Captcha do
  def split(string), do:
    string
      |> String.codepoints
      |> Enum.map(&String.to_integer/1)

  def analyze(pairs), do:
    pairs
      |> Enum.filter(fn({a, b}) -> a == b end)
      |> Enum.map(fn({a, _}) -> a end)
      |> Enum.sum

  def solve1(input_string), do:
    input_string
      |> split
      |> (fn (list) -> List.zip([list, Rotate.left_by1(list)]) end).()
      |> analyze

  def solve2(input_string), do:
    input_string
      |> split
      |> (fn (list) -> List.zip([list, Rotate.left_by_half(list)]) end).()
      |> analyze

  def input, do:
    File.read! "input.txt"

  def solution1, do:
    Captcha.solve1(input())

  def solution2, do:
    Captcha.solve2(input())
end
