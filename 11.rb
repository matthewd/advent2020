# frozen_string_literal: true

room = File.read("11.input").lines.map(&:chomp).map(&:chars)

DIRECTIONS = [-1, 0, 1].repeated_permutation(2).to_a - [[0, 0]]

def valid?(grid, row, col)
  (0...grid.size) === row &&
    (0...grid[row].size) === col
end

def adjacencies(grid, row, col)
  return enum_for(:adjacencies, grid, row, col) unless block_given?

  DIRECTIONS.each do |row_off, col_off|
    new_row = row + row_off
    new_col = col + col_off

    yield grid[new_row][new_col] if valid?(grid, new_row, new_col)
  end
end

def cycle_while_changing(grid)
  old_grid = nil

  while old_grid != grid
    old_grid = grid
    grid = grid.map(&:dup)

    grid.size.times do |row|
      grid[row].map!.with_index do |current, col|
        next current if current == "."

        yield old_grid, row, col
      end
    end
  end

  grid
end

first_result = cycle_while_changing(room) do |current_grid, row, col|
  occupied = adjacencies(current_grid, row, col).count("#")

  if occupied >= 4
    "L"
  elsif occupied == 0
    "#"
  else
    current_grid[row][col]
  end
end

p first_result.map(&:join).join.count("#")


def spokes(grid, row, col)
  return enum_for(:spokes, grid, row, col) unless block_given?

  DIRECTIONS.each do |row_direction, col_direction|
    target_row = row
    target_col = col

    begin
      target_row += row_direction
      target_col += col_direction
    end while valid?(grid, target_row, target_col) && grid[target_row][target_col] == "."

    yield grid[target_row][target_col] if valid?(grid, target_row, target_col)
  end
end

second_result = cycle_while_changing(room) do |current_grid, row, col|
  occupied = spokes(current_grid, row, col).count("#")

  if occupied >= 5
    "L"
  elsif occupied == 0
    "#"
  else
    current_grid[row][col]
  end
end

p second_result.map(&:join).join.count("#")
