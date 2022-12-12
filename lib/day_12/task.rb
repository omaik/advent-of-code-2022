module Day12
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      map = Map.new(input)
      map.traverse
    end

    def call2
      map = Map.new(input)
      map.traverse(cost_reduction: true)
    end

    def input
      @input ||= Input.call(@sample)
    end
  end

  class Map
    attr_reader :finished, :total_steps

    def initialize(map)
      @map = map
      @starting_location = find_location('S')
      @ending_location = find_location('E')
      @costs = {}
      @visits = []
      @finished = []
      @total_steps = 0
    end

    def traverse(cost_reduction: false)
      start

      loop do
        @total_steps += 1
        location, cost = @visits.shift

        cost += 1

        cost = 0 if cost_reduction && @map.dig(*location) == 'a'

        return cost if location == @ending_location

        adjacent(location).each do |next_location|
          next if cost >= @costs.fetch(next_location, Float::INFINITY)

          @costs[next_location] = cost
          index = @visits.index { |x| x[1] >= cost }
          @visits.insert(index || -1, [next_location, cost])
        end
      end
    end

    private

    def start
      adjacent(@starting_location).each do |location|
        @visits << [location, 0]
      end
    end

    def find_location(char)
      @map.each_with_index do |row, y|
        x = row.index(char)
        return [y, x] if x
      end
    end

    def adjacent(location)
      [
        [location[0] - 1, location[1]],
        [location[0] + 1, location[1]],
        [location[0], location[1] - 1],
        [location[0], location[1] + 1]
      ].select do |x|
        x.all? { |y| y >= 0 } && can_visit?(location, x)
      end
    end

    def can_visit?(start, destination)
      return false unless (start_char = @map.dig(*start))
      return false unless (end_char = @map.dig(*destination))

      start_char = replace(start_char)
      end_char = replace(end_char)

      start_char.ord >= end_char.ord - 1
    end

    def replace(char)
      return 'a' if char == 'S'
      return 'z' if char == 'E'

      char
    end
  end
end
