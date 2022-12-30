# 4044 - too lo
# 4206 - too low
# 4208!!

# 6804 - too high

module Day23
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        Map.new(data(sample).split("\n").map { |x| x.split('') })
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end

    class Map
      attr_reader :round, :moved

      def initialize(points)
        @map = Hash.new { |h, k| h[k] = Hash.new('.') }

        points.each_with_index do |row, y|
          row.each_with_index do |point, x|
            @map[y][x] = point
          end
        end

        @round = 0
      end

      def dig(*args)
        @map.dig(*args)
      end

      def area
        positions = find_robots.map(&:position)

        y_min = positions.map(&:first).min
        y_max = positions.map(&:first).max + 1
        x_min = positions.map(&:last).min
        x_max = positions.map(&:last).max + 1

        (y_max - y_min) * (x_max - x_min) - positions.size
      end

      def print_self
        y_dimensions = @map.keys.minmax
        x_dimensions = @map.values.map(&:keys).flatten.minmax
        y_dimensions.first.upto(y_dimensions.last) do |y|
          x_dimensions.first.upto(x_dimensions.last) do |x|
            print @map[y][x]
          end
          puts
        end
      end

      def play_round
        @moved = false
        robots = find_robots

        proposals = robots.map(&:prepare_proposal)

        conflicts = proposals.group_by(&:itself).select { |_, v| v.size > 1 }.keys.uniq

        robots.each do |robot|
          next if conflicts.include?(robot.proposal) || robot.proposal.nil?

          @moved = true
          robot.move
        end
        @round += 1
      end

      def find_robots
        @map.map do |y, row|
          row.filter_map do |x, point|
            Robot.new([y, x], @map, @round) if point == '#'
          end
        end.flatten(1)
      end
    end

    class Robot
      attr_reader :position, :proposal

      def initialize(position, map, round)
        @position = position
        @map = map
        @round = round
      end

      def move
        @map[@position[0]][@position[1]] = '.'

        @map[proposal[0]][proposal[1]] = '#'
      end

      def prepare_proposal
        return nil unless neighbours?

        options = [
          !north_neighbours? ? [@position[0] - 1, @position[1]] : nil,
          !south_neighbours? ? [@position[0] + 1, @position[1]] : nil,
          !west_neighbours? ? [@position[0], @position[1] - 1] : nil,
          !east_neighbours? ? [@position[0], @position[1] + 1] : nil
        ].rotate(@round % 4)

        @proposal = options.compact.first
      end

      def neighbours?
        north_neighbours? || south_neighbours? || east_neighbours? || west_neighbours?
      end

      def north_neighbours?
        [
          @map.dig(@position[0] - 1, @position[1]),
          @map.dig(@position[0] - 1, @position[1] - 1),
          @map.dig(@position[0] - 1, @position[1] + 1)
        ].count('#').nonzero?
      end

      def south_neighbours?
        [
          @map.dig(@position[0] + 1, @position[1]),
          @map.dig(@position[0] + 1, @position[1] - 1),
          @map.dig(@position[0] + 1, @position[1] + 1)
        ].count('#').nonzero?
      end

      def east_neighbours?
        [
          @map.dig(@position[0], @position[1] + 1),
          @map.dig(@position[0] - 1, @position[1] + 1),
          @map.dig(@position[0] + 1, @position[1] + 1)
        ].count('#').nonzero?
      end

      def west_neighbours?
        [
          @map.dig(@position[0], @position[1] - 1),
          @map.dig(@position[0] - 1, @position[1] - 1),
          @map.dig(@position[0] + 1, @position[1] - 1)
        ].count('#').nonzero?
      end
    end
  end
end
