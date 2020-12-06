# frozen_string_literal: true

groups = File.read("6.input").split("\n\n")

p groups.map { |s| s.gsub("\n", "").chars.uniq.size }.sum

p groups.map { |g| g.split.map(&:chars).inject(:&).size }.sum

