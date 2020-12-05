# frozen_string_literal: true

lines = File.read("5.input").lines.map(&:chomp)

seats = lines.map do |line|
  fb = line[0..6]
  lr = line[7..9]

  row = fb.tr("FB", "01").to_i(2)
  column = lr.tr("LR", "01").to_i(2)

  row * 8 + column
end

p seats.max


before, after = seats.sort.each_cons(2).find do |before, after|
  after != before + 1
end

p before + 1
