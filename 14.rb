# frozen_string_literal: true

lines = File.read("14.input").lines.map do |s|
  s =~ /(?:mask|mem\[(\d+)\]) = (\w+)/
  [$1&.to_i, $1 ? $2.to_i : $2]
end

override_mask = 0
override_value = 0

memory = Hash.new(0)

lines.each do |address, value|
  if address.nil?
    override_value = value.tr("X", "0").to_i(2)
    override_mask = value.tr("1X", "01").to_i(2)
  else
    memory[address] = value & override_mask | override_value
  end
end

p memory.values.sum


force_mask = nil
float_mask = nil

memory = Hash.new(0)

lines.each do |address, value|
  if address.nil?
    force_mask = value.tr("X", "0").to_i(2)
    float_mask = value.tr("1X", "01").to_i(2)
  else
    addresses = [address | force_mask]
    float_mask.digits(2).each_with_index do |bit, idx|
      next if bit.zero?

      addresses += addresses.map { |v| v ^ (1 << idx) }
    end

    addresses.each do |addr|
      memory[addr] = value
    end
  end
end

p memory.values.sum

