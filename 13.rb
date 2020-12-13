# frozen_string_literal: true

target, schedules = File.read("13.input").lines

target = target.to_i
schedules = schedules.split(",").map(&:to_i)

nexts = schedules.select(&:positive?).map do |cycle|
  div, mod = target.divmod(cycle)
  div += 1 unless mod.zero?

  [div * cycle - target, cycle]
end.sort

p nexts.first.reduce(:*)


stride = 1
current = 0

schedules.each_with_index do |cycle, offset|
  next unless cycle.positive?

  current += stride until ((current + offset) % cycle).zero?

  stride = stride.lcm(cycle)
end

p current

