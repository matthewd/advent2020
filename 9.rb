# frozen_string_literal: true

numbers = File.read("9.input").lines.map(&:to_i)

bad = nil
numbers.each_cons(26) do |list|
  current = list.pop

  next if list.enum_for(:any?).with_index { |a, idx| list[idx + 1..-1].include?(current - a) }

  bad = current
  break
end

p bad


# How I originally wrote it:

sums = []
numbers.each_with_index do |this, idx|
  sums.map! { |n| n + this }
  sums.unshift this

  sums.pop while sums.last > bad

  if length = sums.index(bad)
    range = numbers[(idx - length)..idx]
    p range.min + range.max
    break
  end
end


# More computationally complex, but neater

window = []
numbers.each do |this|
  window << this

  window.shift while window.sum > bad

  if window.sum == bad
    p window.min + window.max
    break
  end
end

