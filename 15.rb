# frozen_string_literal: true

numbers = File.read("15.input").split(",").map(&:to_i)

latest = numbers.pop

until numbers.size == 2019
  if previous = numbers.rindex(latest)
    this = numbers.size - previous
  else
    this = 0
  end

  numbers << latest
  latest = this
end

p latest


history = {}

latest = 0
numbers.each_with_index do |number, index|
  history[latest] = index
  latest = number
end
numbers.size.upto(29999999) do |index|
  previous = history[latest] ? index - history[latest] : 0
  history[latest] = index
  latest = previous
end

p latest

