module Day15
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        data(sample).split("\n").map do |row|
          Sensor.new(row)
        end
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end
  end

  class Sensor
    attr_reader :sensor_location, :beacon_location, :distance

    def initialize(row)
      match = /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/.match(row)

      @sensor_location = [match[1].to_i, match[2].to_i]
      @beacon_location = [match[3].to_i, match[4].to_i]

      @distance = @sensor_location.zip(@beacon_location).map { |a, b| (a - b).abs }.sum
    end

    def black_window(row)
      direct_distance = (@sensor_location[1] - row).abs

      result = if direct_distance < @distance
                 diff = @distance - direct_distance
                 ((@sensor_location[0] - diff)..(@sensor_location[0] + diff)).to_a
               else
                 []
               end

      result -= [@beacon_location[0]] if @beacon_location[1] == row

      result
    end

    def include?(point)
      ((@sensor_location[0] - point[0]).abs + (@sensor_location[1] - point[1]).abs) <= @distance
    end

    def adjacent(sensors, range)
      dist = @distance + 1
      (dist + 1).times.map do |i|
        [
          [@sensor_location[0] - dist + i, @sensor_location[1] + i], # left -> top
          [@sensor_location[0] + dist - i, @sensor_location[1] + i], # right -> top
          [@sensor_location[0] - dist + i, @sensor_location[1] - i], # left -> bottom
          [@sensor_location[0] + dist - i, @sensor_location[1] - i] # right -> bottom
        ].reject { |point| !in_range?(point, range) || sensors.any? { |x| x.include?(point) } }
      end.flatten(1)
    end

    def in_range?(point, range)
      point.none? { |x| x.negative? || x > range }
    end
  end
end
