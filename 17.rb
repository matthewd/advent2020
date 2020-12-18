# frozen_string_literal: true

DIRECTIONS = Hash.new do |h, k|
  h[k] = [-1, 0, 1].repeated_permutation(k).reject { |c| c.all?(&:zero?) }
end

input = File.read("17.input")

input_plane = input.split.flat_map.with_index do |line, y|
  line.chars.map.with_index do |char, x|
    [x, y] if char == '#'
  end
end.compact

def expand(depth, input_plane)
  Set.new(input_plane.map { |c| c + [0] * (depth - c.size) })
end

def neighbors(depth, coord)
  DIRECTIONS[depth].map do |offset|
    coord.zip(offset).map(&:sum)
  end
end

def cycle(depth, state)
  Set.new(state.flat_map { |c| neighbors(depth, c) }.uniq.select do |coord|
    n = (state & neighbors(depth, coord)).size

    if state.include?(coord)
      n == 2 || n == 3
    else
      n == 3
    end
  end)
end

state = expand(3, input_plane)
6.times do
  state = cycle(3, state)
end

p state.size


state = expand(4, input_plane)
6.times do
  state = cycle(4, state)
end

p state.size

