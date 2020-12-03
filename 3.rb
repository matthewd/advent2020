# frozen_string_literal: true

lines = File.read("3.input").lines.map(&:chomp)

def slope(lines, across, down)
  pos = 0
  lines.enum_for(:count).with_index do |line, idx|
    next unless idx % down == 0

    row = line.chars

    here = row[pos % row.size]

    pos += across

    here == '#'
  end
end

p slope(lines, 3, 1)

x = []
x << slope(lines, 1, 1)
x << slope(lines, 3, 1)
x << slope(lines, 5, 1)
x << slope(lines, 7, 1)
x << slope(lines, 1, 2)

p x.inject(:*)
