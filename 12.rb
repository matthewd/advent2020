# frozen_string_literal: true

instructions = File.read("12.input").lines.map { |s| s =~ /(\w)(\d+)/; [$1, $2.to_i] }

COMPASS = { 0 => "E", 90 => "N", 180 => "W", 270 => "S" }

Point = Struct.new(:x, :y) do
  def move(direction, count)
    case direction
    when "E"
      self.x += count
    when "N"
      self.y += count
    when "W"
      self.x -= count
    when "S"
      self.y -= count
    end
  end

  def distance_from_origin
    x.abs + y.abs
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
    pos.move(COMPASS[facing], count)
  else
    pos.move(direction, count)
  end
end

p pos.distance_from_origin



class Point
  def rotate(degrees)
    (degrees / 90).times do
      self.x, self.y = -self.y, self.x
    end
  end
end

waypoint = Point.new(10, 1)
ship = Point.new(0, 0)

instructions.each do |direction, count|
  case direction
  when "F"
    ship.x += waypoint.x * count
    ship.y += waypoint.y * count
  when "R"
    waypoint.rotate(360 - count)
  when "L"
    waypoint.rotate(count)
  else
    waypoint.move(direction, count)
  end
end

p ship.distance_from_origin

