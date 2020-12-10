# frozen_string_literal: true

adapters = File.read("10.input").lines.map(&:to_i)

adapters.sort!

values = [0, *adapters, adapters.last + 3]

diffs = values.each_cons(2).map do |left, right|
  right - left
end

p diffs.count(1) * diffs.count(3)


paths = { values.last => 1 }

[0, *adapters].reverse_each do |num|
  paths[num] = [1, 2, 3].sum { |offset| paths[num + offset] || 0 }
end

p paths[0]
