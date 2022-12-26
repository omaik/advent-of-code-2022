module Day22
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        map, steps = data(sample).split("\n\n")

        Steps.new(steps, map)
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end
  end

  class Map
    attr_accessor :location

    def initialize(map)
      @hash_map = Hash.new { |h, k| h[k] = Hash.new { |ha, ka| ha[ka] = '_' } }
      map.gsub(' ', '_').each_line.with_index do |line, y|
        line.strip.each_char.with_index do |char, x|
          @hash_map[y][x] = char
        end
      end

      @direction = %w[R D L U]
      @location = Location.new(0, @hash_map[0].values.index('.'), @direction.first)

      @path = [@location]

      @dimensions = [@hash_map.keys.max, @hash_map.values.map(&:keys).flatten.max]
    end

    def print
      puts '========================='
      (0..@dimensions.first).each do |y|
        arr = (0..@dimensions.last).map do |x|
          if (location = @path.detect { |l| l.y == y && l.x == x })
            location.to_s
          else
            @hash_map[y][x]
          end
        end

        puts arr.join('')
      end
      puts '========================='
      puts ''
    end

    def move
      location = next_location

      if @hash_map.dig(*location) == '.'
        @location = Location.new(*location, @direction.first)
        @path << @location
        true
      else
        false
      end
    end

    def next_location
      case @location.direction
      when 'R'
        move_right
      when 'L'
        move_left
      when 'U'
        move_up
      when 'D'
        move_down
      end
    end

    def move_right
      cand = [@location.y, @location.x + 1]
      if @hash_map.dig(*cand) == '_'
        most_left = @hash_map[@location.y].values.index { |x| x != '_' }
        [cand.first, most_left]
      else
        cand
      end
    end

    def move_left
      cand = [@location.y, @location.x - 1]
      if @hash_map.dig(*cand) == '_'
        most_right = @hash_map[@location.y].values.rindex { |x| x != '_' }
        [cand.first, most_right]
      else
        cand
      end
    end

    def move_up
      cand = [@location.y - 1, @location.x]

      if @hash_map.dig(*cand) == '_'
        most_bottom = @hash_map.values.map { |row| row[cand.last] }.rindex { |x| x != '_' }
        [most_bottom, cand.last]
      else
        cand
      end
    end

    def move_down
      cand = [@location.y + 1, @location.x]

      if @hash_map.dig(*cand) == '_'
        most_top = @hash_map.values.map { |row| row[cand.last] }.index { |x| x != '_' }
        [most_top, cand.last]
      else
        cand
      end
    end

    def change_direction(index)
      @direction = @direction.rotate(index)
      @location.direction = @direction.first
    end
  end

  class Steps
    def initialize(steps, map)
      @moves = steps.strip.gsub('L', 'L_').gsub('R', 'R_').split('_')

      @map = map

      @moves.map! do |move|
        move.match(/(\d+)(L|R)?/)[1..2].compact
      end.flatten!
    end

    def perform_moves(sample: false, cubic: false)
      @map = if cubic
               sample ? SampleCubicMap.new(@map) : CubicMap.new(@map)
             else
               Map.new(@map)
             end

      @moves.each do |move|
        case move
        when 'L'
          @map.change_direction(-1)
        when 'R'
          @map.change_direction(1)
        else
          move.to_i.times do
            break unless @map.move
          end
        end
      end

      @map.location.score
    end
  end

  class Location
    attr_accessor :y, :x, :direction

    def initialize(y, x, direction)
      @y = y
      @x = x
      @direction = direction
    end

    def to_s
      {
        'R' => '>',
        'L' => '<',
        'U' => '^',
        'D' => 'v'
      }[direction]
    end

    def score
      1000 * (y + 1) + 4 * (x + 1) + %w[R D L U].index(direction)
    end
  end

  class CubicMap < Map # rubocop:disable Metrics/ClassLength
    CUBES = {
      'A' => {
        space: [50..99, 50..99],
        right_wrap: {
          to: 'C',
          approach_from: 'D'
        },
        left_wrap: {
          to: 'E',
          approach_from: 'U'
        },
        up_wrap: {
          to: 'B',
          approach_from: 'D'
        },

        down_wrap: {
          to: 'D',
          approach_from: 'U'
        }
      },

      'B' => {
        space: [0..49, 50..99],
        right_wrap: {
          to: 'C',
          approach_from: 'L'
        },
        left_wrap: {
          to: 'E',
          approach_from: 'L'
        },
        up_wrap: {
          to: 'F',
          approach_from: 'L'
        },
        down_wrap: {
          to: 'A',
          approach_from: 'U'
        }
      },

      'C' => {
        space: [0..49, 100..149],
        right_wrap: {
          to: 'D',
          approach_from: 'R'
        },
        left_wrap: {
          to: 'B',
          approach_from: 'R'
        },
        up_wrap: {
          to: 'F',
          approach_from: 'D'
        },
        down_wrap: {
          to: 'A',
          approach_from: 'R'
        }
      },

      'D' => {
        space: [100..149, 50..99],

        right_wrap: {
          to: 'C',
          approach_from: 'R'
        },

        left_wrap: {
          to: 'E',
          approach_from: 'R'
        },

        up_wrap: {
          to: 'A',
          approach_from: 'D'
        },

        down_wrap: {
          to: 'F',
          approach_from: 'R'
        }
      },

      'E' => {
        space: [100..149, 0..49],
        right_wrap: {
          to: 'D',
          approach_from: 'L'
        },

        left_wrap: {
          to: 'B',
          approach_from: 'L'
        },

        up_wrap: {
          to: 'A',
          approach_from: 'L'
        },

        down_wrap: {
          to: 'F',
          approach_from: 'U'
        }
      },

      'F' => {
        space: [150..199, 0..49],
        right_wrap: {
          to: 'D',
          approach_from: 'D'
        },

        left_wrap: {
          to: 'B',
          approach_from: 'U'
        },

        up_wrap: {
          to: 'E',
          approach_from: 'D'
        },

        down_wrap: {
          to: 'C',
          approach_from: 'U'
        }
      }
    }.freeze

    SIZE = 49

    def initialize(map)
      super
      @current_cube = self.class::CUBES.values.detect do |x|
        x[:space][0].include?(@location.y) && x[:space][1].include?(@location.x)
      end
    end

    def move
      location, direction, cube = next_location

      if @hash_map.dig(*location) == '.'
        @current_cube = cube
        adjust_direction(direction)

        @location = Location.new(*location, @direction.first)
        @path << @location
        true
      else
        false
      end
    end

    def adjust_direction(direction)
      loop do
        break if @direction.first == direction

        @direction = @direction.rotate(1)
      end
    end

    def next_location
      new_location = case @location.direction
                     when 'R'
                       [@location.y, @location.x + 1]
                     when 'L'
                       [@location.y, @location.x - 1]
                     when 'U'
                       [@location.y - 1, @location.x]
                     when 'D'
                       [@location.y + 1, @location.x]
                     end

      if @current_cube[:space][0].include?(new_location[0]) && @current_cube[:space][1].include?(new_location[1])
        [new_location, @location.direction, @current_cube]
      else
        perform_jump
      end
    end

    def perform_jump
      relative_coordinates = [@location.y - @current_cube[:space][0].first,
                              @location.x - @current_cube[:space][1].first]

      wrap_key = {
        'R' => :right_wrap,
        'L' => :left_wrap,
        'D' => :down_wrap,
        'U' => :up_wrap
      }[@location.direction]

      wrap_logic = @current_cube[wrap_key]

      new_cube = self.class::CUBES[wrap_logic[:to]]

      new_relative_coordinates = move_logic[@location.direction][wrap_logic[:approach_from]].call(*relative_coordinates)

      new_absolute_coordinates = [
        new_relative_coordinates[0] + new_cube[:space][0].first,
        new_relative_coordinates[1] + new_cube[:space][1].first
      ]

      new_direction = {
        'R' => 'L',
        'L' => 'R',
        'U' => 'D',
        'D' => 'U'
      }[wrap_logic[:approach_from]]

      [new_absolute_coordinates, new_direction, new_cube]
    end

    def move_logic
      size = self.class::SIZE

      { 'R' => {
          'R' => ->(y, _x) { [size - y, size] },
          'L' => ->(y, _x) { [y, 0] },
          'U' => ->(y, _x) { [0, size - y] },
          'D' => ->(y, _x) { [size, y] }
        },
        'L' => {
          'R' => ->(y, _x) { [y, size] },
          'L' => ->(y, _x) { [size - y, 0] },
          'U' => ->(y, _x) { [0, y] },
          'D' => ->(y, _x) { [size, size - y] }
        },
        'U' => {
          'R' => ->(_y, x) { [size - x, size] },
          'L' => ->(_y, x) { [x, 0] },
          'U' => ->(_y, x) { [0, size - x] },
          'D' => ->(_y, x) { [size, x] }
        },
        'D' => {
          'R' => ->(_y, x) { [x, size] },
          'L' => ->(_y, x) { [size - x, 0] },
          'U' => ->(_y, x) { [0, x] },
          'D' => ->(_y, x) { [size, size - x] }
        } }
    end
  end

  class SampleCubicMap < CubicMap # rubocop:disable Metrics/ClassLength
    SIZE = 3

    CUBES = {
      'D' => { # 4 in writting
        space: [4..7, 8..11],
        right_wrap: {
          to: 'F',
          approach_from: 'U'
        },
        left_wrap: {
          to: 'C',
          approach_from: 'R'
        },
        up_wrap: {
          to: 'A',
          approach_from: 'D'
        },
        down_wrap: {
          to: 'E',
          approach_from: 'U'
        }
      },
      'E' => { # 5 in writting
        space: [8..11, 8..11],
        right_wrap: {
          to: 'F',
          approach_from: 'L'
        },
        left_wrap: {
          to: 'C',
          approach_from: 'D'
        },
        up_wrap: {
          to: 'D',
          approach_from: 'D'
        },
        down_wrap: {
          to: 'B',
          approach_from: 'D'
        }
      },
      'F' => { # 6 in writting
        space: [8..11, 12..15],
        right_wrap: {
          to: 'A',
          approach_from: 'R'
        },
        left_wrap: {
          to: 'E',
          approach_from: 'R'
        },
        up_wrap: {
          to: 'D',
          approach_from: 'R'
        },
        down_wrap: {
          to: 'B',
          approach_from: 'L'
        }
      },

      'C' => { # 3 in writting
        space: [4..7, 4..7],
        right_wrap: {
          to: 'D',
          approach_from: 'L'
        },
        left_wrap: {
          to: 'B',
          approach_from: 'R'
        },
        up_wrap: {
          to: 'A',
          approach_from: 'L'
        },
        down_wrap: {
          to: 'E',
          approach_from: 'L'
        }
      },

      'B' => { # 2 in writting
        space: [4..7, 0..3],
        right_wrap: {
          to: 'C',
          approach_from: 'L'
        },
        left_wrap: {
          to: 'F',
          approach_from: 'D'
        },
        up_wrap: {
          to: 'A',
          approach_from: 'U'
        },
        down_wrap: {
          to: 'E',
          approach_from: 'D'
        }
      },

      'A' => { # 1 in writting
        space: [0..3, 8..11],
        right_wrap: {
          to: 'F',
          approach_from: 'R'
        },

        left_wrap: {
          to: 'C',
          approach_from: 'U'
        },

        up_wrap: {
          to: 'B',
          approach_from: 'U'
        },

        down_wrap: {
          to: 'D',
          approach_from: 'U'
        }
      }
    }.freeze
  end
end
