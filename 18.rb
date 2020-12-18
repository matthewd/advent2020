# frozen_string_literal: true

lines = File.read("18.input").lines(chomp: true)

def expand(expression)
  while expression.include?("(")
    expression = expression.gsub(/\(([^()]+)\)/) { yield $1 }
  end

  expression
end

def evaluate_equally(expression)
  initial, *parts = expand(expression, &method(:evaluate_equally)).split

  parts.each_slice(2).reduce(initial.to_i) do |acc, (op, num)|
    acc.send(op, num.to_i)
  end
end

p lines.sum { |line| evaluate_equally(line) }


def evaluate_inverted(expression)
  expand(expression, &method(:evaluate_inverted)).
    split(" * ").map do |mult|
      mult.split(" + ").map(&:to_i).sum
    end.reduce(:*)
end

p lines.sum { |line| evaluate_inverted(line) }

