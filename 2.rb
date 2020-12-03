# frozen_string_literal: true

lines = File.read("2.input").lines.map(&:chomp)

valid = lines.count do |line|
  line =~ /(\d+)-(\d+) (.): (.*)/
  min, max, char, password = $1, $2, $3, $4

  range = min.to_i..max.to_i

  count = password.count(char)

  range.include?(count)
end

p valid


valid = lines.count do |line|
  line =~ /(\d+)-(\d+) (.): (.*)/
  p1, p2, char, password = $1, $2, $3, $4

  c1 = password[p1.to_i - 1]
  c2 = password[p2.to_i - 1]

  (c1 == char) ^ (c2 == char)
end

p valid
