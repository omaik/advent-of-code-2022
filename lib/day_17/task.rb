module Day17
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      map = Map.new(input.size)
      e = Enumerator.new do |y|
        input.cycle.with_index do |x, i|
          y << [x, i]
        end
      end

      map.iterate(e, 2022)
    end

    def call2
      map = Map.new(input.size)
      e = Enumerator.new do |y|
        input.cycle.with_index do |x, i|
          y << [x, i]
        end
      end

      map.iterate(e, 1_000_000_000_000)
    end

    def input
      @input ||= Input.call(@sample)
    end
  end

  class Map
    attr_reader :container, :top_level, :shapes_count, :current_shape

    def initialize(input_size)
      @input_size = input_size
      @container = Hash.new do |h, k|
        h[k] = Array.new(7) { '.' }
      end
      @top_level = 0
      @total_steps = 0
      @shapes_count = 0
      @samples = []
      @shapes_table = {}
    end

    def print
      @top_level.times do |i|
        puts @container[@top_level - i].map.with_index { |x, j|
               @current_shape&.coordinates&.include?([j, @top_level - i]) ? '@' : x
             }.join
      end
    end

    def print_to_file
      File.open('output.txt', 'w') do |f|
        @top_level.times do |i|
          f.puts @container[@top_level - i].map.with_index { |x, j|
                   @current_shape&.coordinates&.include?([j, @top_level - i]) ? '@' : x
                 }.join
        end
      end
    end

    def iterate(enumerator, duration)
      loop do
        direction, location = enumerator.next

        mode = @input_size < 200 ? @input_size * 5 : @input_size
        @samples << [@top_level, @shapes_count] if (location % mode).zero? && @shapes_count.positive?

        return @top_level if @shapes_count == duration

        if @samples.size == 2
          first, last = @samples

          steps = (duration / (last[1] - first[1]))
          gap = duration - (last[1] - first[1]) * steps
          points = steps * (last[0] - first[0]) + @shapes_table[gap]
          return points
        end

        next_step(direction)
      end
    end

    def next_step(direction) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      @total_steps += 1
      @current_shape ||= SHAPES[shapes_count % 5].new(@top_level)

      if direction == '>'
        @current_shape.center_point[0] += 1 unless @current_shape.touching_right?(@container)
      else
        @current_shape.center_point[0] -= 1 unless @current_shape.touching_left?(@container)
      end

      old_coordinates = @current_shape.coordinates.deep_dup
      @current_shape.center_point[1] -= 1

      coordinates = @current_shape.coordinates

      return unless overlapping?(coordinates)

      @current_shape = nil
      save_coordinates(old_coordinates)
      @top_level = @container.select { |_x, y| y.include?('#') }.map(&:first).max
      @shapes_count += 1
      @shapes_table[@shapes_count] = @top_level
    end

    def overlapping?(coordinates)
      coordinates.any? do |coordinate|
        @container[coordinate[1]][coordinate[0]] == '#' || (coordinate[1]).zero?
      end
    end

    def save_coordinates(coordinates)
      coordinates.each do |coordinate|
        @container[coordinate[1]][coordinate[0]] = '#'
      end
    end
  end

  class Shape
    attr_accessor :stopped

    def initialize(bottom_point)
      @center = center(bottom_point)
      @stopped = false
    end

    def center_point
      @center
    end

    def touching_left?(container)
      coordinates.any? { |x| x[0].zero? || container[x[1]][x[0] - 1] == '#' }
    end

    def touching_right?(container)
      coordinates.any? { |x| x[0] == 6 || container[x[1]][x[0] + 1] == '#' }
    end

    def coordinates; end
  end

  class Cross < Shape
    def center(bottom_point)
      [3, bottom_point + 5]
    end

    def coordinates
      [@center,
       [@center[0] - 1, @center[1]],
       [@center[0] + 1, @center[1]],
       [@center[0], @center[1] - 1],
       [@center[0], @center[1] + 1]]
    end
  end

  class HorizontalLine < Shape
    def center(bottom_point)
      [3, bottom_point + 4]
    end

    def coordinates
      [@center,
       [@center[0] - 1, @center[1]],
       [@center[0] + 1, @center[1]],
       [@center[0] + 2, @center[1]]]
    end
  end

  class L < Shape
    def center(bottom_point)
      [4, bottom_point + 4]
    end

    def coordinates
      [@center,
       [@center[0] - 1, @center[1]],
       [@center[0] - 2, @center[1]],
       [@center[0], @center[1] + 1],
       [@center[0], @center[1] + 2]]
    end
  end

  class VerticalLine < Shape
    def center(bottom_point)
      [2, bottom_point + 5]
    end

    def coordinates
      [@center,
       [@center[0], @center[1] - 1],
       [@center[0], @center[1] + 1],
       [@center[0], @center[1] + 2]]
    end
  end

  class Square < Shape
    def center(bottom_point)
      [3, bottom_point + 4]
    end

    def coordinates
      [
        @center,
        [@center[0] - 1, @center[1]],
        [@center[0], @center[1] + 1],
        [@center[0] - 1, @center[1] + 1]
      ]
    end
  end

  SHAPES = [HorizontalLine, Cross, L, VerticalLine, Square].freeze
end
