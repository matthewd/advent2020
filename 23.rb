# frozen_string_literal: true

cups = File.read("23.input").chomp.chars.map(&:to_i)

lowest = cups.min

100.times do
  current = cups.shift
  three = cups.shift(3)

  destination = current - 1
  destination -= 1 until cups.include?(destination) || destination < lowest
  destination = cups.max if destination < lowest

  dest_idx = cups.index(destination)

  cups.insert(dest_idx + 1, *three)
  cups.push current
end

cups.rotate! cups.index(1)
puts cups.drop(1).join

