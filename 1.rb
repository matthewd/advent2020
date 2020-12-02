# frozen_string_literal: true

inputs = File.read("1.input").lines.map(&:to_i)

b = nil
a = inputs.find do |x|
  b = 2020 - x
  inputs.include?(b)
end
p a * b

b = nil
c = nil
a = inputs.find do |x|
  b = inputs.find do |y|
    c = 2020 - x - y
    inputs.include?(c)
  end
end
p a * b * c
