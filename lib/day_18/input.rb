module Day18
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        data(sample).split("\n").map { |x| Cube.new(x.split(',').map(&:to_i)) }
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end

    class Cube
      attr_reader :x, :y, :z

      def initialize(coordinates)
        @x, @y, @z = coordinates
      end

      def value
        [x, y, z]
      end

      def ==(other)
        x == other.x && y == other.y && z == other.z
      end

      def equal?(other)
        self == other
      end

      def eql?(other)
        self == other
      end

      def face_neighbors
        [
          [x - 1, y, z],
          [x + 1, y, z],
          [x, y - 1, z],
          [x, y + 1, z],
          [x, y, z - 1],
          [x, y, z + 1]
        ].map { |coord| Cube.new(coord) }
      end

      def outside?(x_range, y_range, z_range)
        x < x_range.first || x > x_range.last ||
          y < y_range.first || y > y_range.last ||
          z < z_range.first || z > z_range.last
      end
    end
  end
end
