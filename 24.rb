# frozen_string_literal: true

walks = File.read("24.input").lines.map do |line|
  line.scan(/[ns]?[ew]/)
end

def step(pos, move)
  pos.dup.tap do |new_pos|
    case move
    when "w", "nw"
      new_pos[0] -= 1
    when "e", "se"
      new_pos[0] += 1
    end

    case move
    when "nw", "ne"
      new_pos[1] -= 1
    when "sw", "se"
      new_pos[1] += 1
    end
  end
end

grid = Set.new

walks.each do |walk|
  tile = walk.inject([0, 0]) { |pos, move| step(pos, move) }
  grid.delete(tile) unless grid.add?(tile)
end

p grid.size


def adjacent(pos)
  %w(e w ne nw se sw).map do |move|
    step(pos, move)
  end
end

100.times do
  known_tiles = grid | grid.flat_map { |k| adjacent(k) }

  grid = known_tiles.select! do |pos|
    neighbors = (grid & adjacent(pos)).size

    grid.include?(pos) && neighbors == 1 || neighbors == 2
  end
end

p grid.size

