# frozen_string_literal: true

fields = %w(byr iyr eyr hgt hcl ecl pid cid) - %w(cid)

passports = File.read("4.input").split(/\n\n+/).map { |s| s.split.map { |pair| pair.split(?:) }.to_h }

valid = passports.count { |pp| (fields - pp.keys).empty? }
p valid


validations = {
  "byr" => 1920..2002,
  "iyr" => 2010..2020,
  "eyr" => 2020..2030,
  "hgt" => -> value do
    case value
    when /\A\d+cm\z/; (150..193) === value.to_i
    when /\A\d+in\z/; (59..76) === value.to_i
    end
  end,
  "hcl" => /\A#[0-9a-f]{6}\z/,
  "ecl" => /\A(amb|blu|brn|gry|grn|hzl|oth)\z/,
  "pid" => /\A\d{9}\z/,
}

def valid?(value, check)
  case check
  when Range
    number = value.to_i
    return false unless number.to_s == value
    check === number
  else
    check === value
  end
end

valid = passports.count { |pp|
  validations.all? { |key, check| valid?(pp[key], check) }
}
p valid
