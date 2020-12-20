# frozen_string_literal: true

def alternate_grids(grid)
  [
    rotate(grid),
    rotate(rotate(grid)),
    rotate(rotate(rotate(grid))),
    grid.reverse,
    rotate(grid.reverse),
    rotate(rotate(grid.reverse)),
    rotate(rotate(rotate(grid.reverse))),
  ]
end

def rotate(grid)
  grid.transpose.map(&:reverse)
end

Tile = Struct.new(:number, :content) do
  def permutations
    [self] + alternate_grids(content).map { |c| Tile.new(number, c) }
  end

  def for_borders(top, left)
    permutations.select { |perm| (!top || perm.top_border == top) && (!left || perm.left_border == left) }
  end

  def top_border
    content.first
  end

  def left_border
    content.transpose.first
  end

  def right_border
    content.transpose.last
  end

  def bottom_border
    content.last
  end

  def image_body
    content[1..-2].map { |row| row[1..-2] }
  end
end

borders = Hash.new { |h, k| h[k] = Set.new }

tiles = File.read("20.input").split("\n\n").map do |block|
  Tile.new(block[5..].to_i, block.split("\n").drop(1).map(&:chars))
end

tiles_by_id = {}
tiles.each do |tile|
  tiles_by_id[tile.number] = tile

  tile.permutations.each do |perm|
    borders[perm.top_border].add(tile.number)
  end
end

numbers = Set.new(tiles.map(&:number))

stack = [tiles.flat_map(&:permutations)]
solution = []

column_height = Math.sqrt(tiles.size).to_i

until stack.empty?
  solution << stack.last.shift

  break if solution.size == numbers.size

  candidates = numbers - solution.map(&:number)

  above = nil
  if solution.size % column_height != 0
    above = solution.last.bottom_border
    candidates &= borders[above]
  end

  left = nil
  if solution.size >= column_height
    left = solution[-column_height].right_border
    candidates &= borders[left]
  end

  stack << candidates.flat_map { |num| tiles_by_id[num].for_borders(above, left) }

  while stack.last.empty?
    stack.pop
    solution.pop
  end
end

result_grid = solution.map(&:number).each_slice(column_height).to_a
p result_grid.first.first * result_grid.first.last * result_grid.last.first * result_grid.last.last


image = solution.each_slice(column_height).to_a.transpose.flat_map do |cell_row|
  image_cells = cell_row.map(&:image_body)

  image_cells.first.size.times.map do |idx|
    image_cells.map { |cell| cell[idx] }.inject(:+)
  end
end

MONSTER = ["                  # ", "#    ##    ##    ###", " #  #  #  #  #  #   "].map(&:chars)
def mark_monsters(image)
  monster_count = 0

  image.each_cons(MONSTER.size).with_index do |rows, row_idx|
    rows.transpose.each_cons(MONSTER.first.size).map(&:transpose).each_with_index do |sector, col_idx|
      is_monster =
        sector.zip(MONSTER).all? do |sector_row, monster_row|
          sector_row.zip(monster_row).all? { |sector_value, monster_value| sector_value == monster_value || monster_value != "#" }
        end

      if is_monster
        monster_count += 1

        MONSTER.each.with_index(row_idx) do |monster_row, monster_row_idx|
          monster_row.each.with_index(col_idx) do |monster_value, monster_col_idx|
            if monster_value == "#"
              image[monster_row_idx][monster_col_idx] = "O"
            end
          end
        end
      end
    end
  end

  monster_count
end

images = ([image] + alternate_grids(image)).map(&:dup)

monsteriest_image = images.max_by { |img| mark_monsters(img) }

p monsteriest_image.flatten.count("#")

