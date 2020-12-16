# frozen_string_literal: true

Field = Struct.new(:label, :ranges, :positions) do
  def valid?(value)
    ranges.any? { |r| r === value }
  end

  def found?
    positions.size == 1
  end
end

sections = File.read("16.input").split("\n\n")

rules = sections[0].lines.map do |line|
  label, rule = line.split(": ")

  ranges = rule.split(" or ").map do |pair|
    from, to = pair.split("-")
    from.to_i..to.to_i
  end

  Field.new(label, ranges)
end

mine = sections[1].lines.drop(1).map { |line| line.split(",").map(&:to_i) }.first
nearby = sections[2].lines.drop(1).map { |line| line.split(",").map(&:to_i) }


all_ranges = rules.flat_map(&:ranges)
# assumes there are no holes in the union of the ranges:
full_range = (all_ranges.map(&:begin).min)..(all_ranges.map(&:end).max)

p nearby.flatten.reject { |n| full_range === n }.sum


columns = nearby.select { |row| row.all? { |num| full_range === num } }.transpose

rules.each do |rule|
  rule.positions = (0...mine.size).select { |pos| columns[pos].all? { |v| rule.valid?(v) } }
end

until rules.all?(&:found?)
  fixed_positions = rules.select(&:found?).flat_map(&:positions)

  rules.each do |rule|
    rule.positions -= fixed_positions unless rule.found?
  end
end

departure_rules = rules.select { |rule| rule.label.start_with?("departure") }
p mine.values_at(*departure_rules.flat_map(&:positions)).reduce(:*)

