defmodule Spiral do
  def calc_successor({x, y}, ring_number) do
    # counter clockwise order, go to outer ring when in lower right corner
    cond do
      x ==  ring_number and y == -ring_number -> {x+1, y  } # lower right corner
      x ==  ring_number and y ==  ring_number -> {x-1, y  } # upper right corner
      x == -ring_number and y ==  ring_number -> {x,   y-1} # upper left corner
      x == -ring_number and y == -ring_number -> {x+1, y  } # lower left corner
      x ==  ring_number                       -> {x  , y+1} # right side
      x == -ring_number                       -> {x  , y-1} # left side
      y ==  ring_number                       -> {x-1, y  } # top side
      y == -ring_number                       -> {x+1, y  } # bottom side
    end
  end

  def successor(coords) do
    calc_successor(coords, current_ring(coords))
  end

  def follow_spiral_from(0, coordinate), do: coordinate
  def follow_spiral_from(moves, coordinate) do
    follow_spiral_from(moves-1, successor(coordinate))
  end

  def find_position_of(input) do
    # offset by 1 => 1 implies 0 moves
    follow_spiral_from(input-1, {0,0})
  end

  def hamming_distance({x, y}), do: abs(x) + abs(y)

  def solve1_iterative(input) do
    input
      |> find_position_of
      |> hamming_distance
  end

  def odd_root_above(number) do
    number
      |> :math.sqrt
      |> Float.ceil
      |> round
      |> (fn (k) -> (if rem(k,2) == 1 do k else k+1 end) end).()
  end

  def solve1_direct(1), do: 0
  def solve1_direct(input) do
    # In this spiral memory, each number is in a square ring.
    # Let's call the ring number => n
    # The number of moves to reach the center can be decomposed in:
    # 1) Move count to reach the "center cross"
    #    (numbers directly above, below or to the side of the central square).
    #    Do this by:
    #      a) Map number to the ring perimeter => r1 = L²-input
    #      b) Map r1 to side of the ring => r2 = r1 mod (L-1)
    #      c) Map r2 to distance from center of the side => r3 = r2 - n
    #    Summary:
    #    Move count to center cross => m = |((L²-input) mod (L-1)) - n|
    #
    # 2) Move count to reach the center from given ring,
    #    equal to the ring number => n.
    #
    # Total move count is => m + n = |((L²-input) mod (L-1)) - n| + n

         # Length of the square ring in which the number is (L)
    with side_L <- odd_root_above(input),

         # Number of this square ring "2*n+1 = L"
         ring_n <- div(side_L, 2),

         # Map squares along perimeter total "4*(L-1)"
         # to naturals 0,1,....
         # Do this by subtracting from largest number in square "L²"
         dist_in_perimeter <- side_L * side_L - input,

         # Map above to distance along any of the 4 sides "mod (L-1)"
         dist_in_side <- rem(dist_in_perimeter, side_L - 1),

         # Move count to center cross:
         # absolute value of the difference from the center of the side
         # Center of the side distance from edge = half the side length = n
         dist_from_cross <- abs(dist_in_side - ring_n),
      do: dist_from_cross + ring_n
  end

  def neighbors({x, y}) do
    [{x, y+1}, {x, y-1},     # up and down
     {x+1, y}, {x-1, y},     # right and left
     {x+1, y+1}, {x+1, y-1}, # right corners
     {x-1, y+1}, {x-1, y-1}] # left corners
  end

  def current_ring({x, y}) do
    max(abs(x), abs(y))
  end

  def neighbors_sum(map, coordinate) do
    coordinate
      |> Spiral.neighbors
      |> Enum.filter(&Map.has_key?(map, &1))
      |> Enum.map(&Map.get(map, &1))
      |> Enum.sum
  end

  def find_bigger_than(map, coordinate, threshold) do
    if map[coordinate] > threshold do
      map[coordinate]
    else
      with next_coord <- successor(coordinate),
           new_value <- neighbors_sum(map, next_coord),
           updated_map <- Map.put(map, next_coord, new_value),
        do: find_bigger_than(updated_map, next_coord, threshold)
    end
  end

  def solve2(input) do
    find_bigger_than(%{{0,0} => 1}, {0,0}, input)
  end

  def input, do: 312051

  def solution1_iterative, do: solve1_iterative(input())

  def solution1_direct, do: solve1_direct(input())

  def solution2, do: solve2(input())
end