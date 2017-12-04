defmodule Passphrase do
  def split(input_string) do
    input_string
      |> String.split("\n")
      |> Enum.filter(fn (line) -> String.length(line) > 0 end)
  end

  def has_repetetions?(word_list) do
    Enum.count(Enum.uniq(word_list)) == Enum.count(word_list)
  end

  def check_phrase(phrase) do
    phrase
      |> String.split(" ")
      |> has_repetetions?
  end

  def sort_letters(word) do
    word
      |> String.codepoints
      |> Enum.sort
      |> Enum.join
  end

  def check_anagrams(phrase) do
    phrase
      |> String.split(" ")
      |> Enum.map(&Passphrase.sort_letters/1)
      |> has_repetetions?
  end

  def solve1(input_string) do
    input_string
      |> split
      |> Enum.filter(&Passphrase.check_phrase/1)
      |> Enum.count
  end

  def solve2(input_string) do
    input_string
      |> split
      |> Enum.filter(&Passphrase.check_anagrams/1)
      |> Enum.count
  end

  def input, do: File.read! "input.txt"

  def solution1, do: solve1(input())

  def solution2, do: solve2(input())
end