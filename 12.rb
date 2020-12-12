# frozen_string_literal: true

instructions = File.read("12.input").lines.map { |s| s =~ /(\w)(\d+)/; [$1, $2.to_i] }

class Point < Struct.new(:x, :y)
  def self.new(*)
    super.freeze
  end

  COMPASS = { "E" => 0, "N" => 90, "W" => 180, "S" => 270 }
  UNIT = new(1, 0)

  def self.at(angle)
    UNIT.rotate(COMPASS[angle] || angle)
  end

  def +(other)
    Point.new(x + other.x, y + other.y)
  end

  def *(num)
    Point.new(x * num, y * num)
  end

  def distance_from_origin
    x.abs + y.abs
  end

  def rotate(degrees)
    case degrees
    when 0 then self
    when 90 then Point.new(-y, x)
    when 180 then Point.new(-x, -y)
    when 270 then Point.new(y, -x)
    end
  end
end

pos = Point.new(0, 0)
facing = 0

instructions.each do |direction, count|
  case direction
  when "L"
    facing += count
    facing %= 360
  when "R"
    facing -= count
    facing %= 360
  when "F"
    pos += Point.at(facing) * count
  else
    pos += Point.at(direction) * count
  end
end

p pos.distance_from_origin


waypoint = Point.new(10, 1)
ship = Point.new(0, 0)

instructions.each do |direction, count|
  case direction
  when "F"
    ship += waypoint * count
  when "R"
    waypoint = waypoint.rotate(360 - count)
  when "L"
    waypoint = waypoint.rotate(count)
  else
    waypoint += Point.at(direction) * count
  end
end

p ship.distance_from_origin
