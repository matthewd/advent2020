# frozen_string_literal: true

lines = File.read("8.input").lines.map(&:chomp)

ops = lines.map { |l| o, n = l.split; [o, n.to_i] }

def run(ops)
  ptr = 0
  acc = 0
  visited = []

  while ptr < ops.size
    return [false, acc] if visited[ptr]
    visited[ptr] = true

    op, num = ops[ptr]

    case op
    when "acc"
      acc += num
      ptr += 1
    when "jmp"
      ptr += num
    when "nop"
      ptr += 1
    end
  end

  [true, acc]
end

p run(ops)[1]


ops.each_with_index do |(op, num), idx|
  next if op == "acc"

  new_ops = ops.dup
  new_ops[idx] = [op == "jmp" ? "nop" : "jmp", num]

  finished, acc = run(new_ops)

  if finished
    p acc
    break
  end
end

