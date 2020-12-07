# frozen_string_literal: true

lines = File.read("7.input").lines.map(&:chomp)

bags = {}
lines.each do |line|
  line =~ /\A(.*) bags contain (.*)\.\z/
  this = $1
  bags[this] = {}

  $2.split(", ").each do |rule|
    if rule =~ /\A(\d+) (.*) bags?\z/
      bags[this][$2] = $1.to_i
    end
  end
end

new_bags = ["shiny gold"]
bags_of_holding = Set.new

while new_bag = new_bags.shift
  bags.each do |bag, rules|
    next unless rules[new_bag]

    if bags_of_holding.add?(bag)
      new_bags << bag
    end
  end
end

p bags_of_holding.size


def nested_bags(bags, bag)
  bags[bag].sum { |inner, count| count * (1 + nested_bags(bags, inner)) }
end

p nested_bags(bags, "shiny gold")
