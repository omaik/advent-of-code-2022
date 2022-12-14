module Day14
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      map = Map.new(input)
      map.fill_in
      map.map.values.map(&:values).flatten.count('o')
    end

    def call2
      map = Map.new(input, endless: false)
      map.fill_in
      map.map.values.map(&:values).flatten.count('o')
    end

    def input
      @input ||= Input.call(@sample)
    end
  end

  class Map
    attr_reader :map

    def initialize(lines, endless: true)
      @map = Hash.new { |h, k| h[k] = Hash.new { |h2, k2| h2[k2] = '.' } }
      draw_lines(lines)
      @lowest_point = map.keys.max
      @endless = endless
      return if endless

      @map[@lowest_point + 2].default = '#'
    end

    def print_self
      y_range = (map.keys.min..map.keys.max)
      x_range = (map.values.map(&:keys).flatten.min..map.values.map(&:keys).flatten.max)

      puts "Using ranges #{y_range} and #{x_range}"

      y_range.each do |y|
        x_range.each do |x|
          print map[y][x]
        end
        puts ''
      end
    end

    def fill_in
      loop do
        sand_location = [0, 500]

        break unless move_sand(sand_location)
      end
    end

    private

    def move_sand(location)
      new_location = adjacent(location).detect { |x| map.dig(*x) == '.' }

      if new_location.nil?
        return false unless @map.dig(*location) == '.'

        @map[location[0]][location[1]] = 'o'
        return true

      end

      return false if @endless && new_location[0] > @lowest_point

      move_sand(new_location)
    end

    def adjacent(location)
      y, x = location
      [[y + 1, x], [y + 1, x - 1], [y + 1, x + 1]]
    end

    def draw_lines(lines)
      lines.each do |line|
        draw_line(line)
      end
    end

    def draw_line(line)
      line.each_cons(2) do |point1, point2|
        y_range = Range.new(*[point1.last, point2.last].sort)
        x_range = Range.new(*[point1.first, point2.first].sort)

        y_range.each do |y|
          x_range.each do |x|
            @map[y][x] = '#'
          end
        end
      end
    end
  end
end
