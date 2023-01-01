module Day24
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        Map.new(data(sample))
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end
  end

  class Simulation
    class << self
      def registry(sim)
        @registry ||= []
        index = @registry.index { |x| (x.score >= sim.score) }

        @registry.insert(index || -1, sim)
        @registry << sim
      end

      def cache(key)
        @cache ||= {}

        @cache[key] = 1
      end

      def cached?(key)
        @cache&.key?(key)
      end

      def add_finish(sim)
        finishes << sim
        @min_finish = finishes.min_by(&:round).round
      end

      def min_finish
        @min_finish || 1000
      end

      def finishes
        @finishes ||= []
      end

      def play(map, start, ending, round)
        @registry = []
        @finishes = []
        @min_finish = nil
        @cache = {}

        registry(new(map, start, ending, round))

        loop do
          sim = @registry.shift
          return @min_finish if sim.nil?

          sim.play_round
        end
      end
    end

    attr_accessor :round, :position, :path, :destination, :map, :round_counter

    def initialize(map, start, ending, round)
      @map = map
      @round = round
      @round_counter = 0
      @position = start
      @starting_position = start
      @path = []
      @destination = ending
    end

    def score
      (destination.sum - position.sum).abs
    end

    def play_round
      if @position == @destination
        Simulation.add_finish(self)
        return
      end

      theoretical_finish = round + (destination.sum - position.sum).abs * 2
      return if Simulation.min_finish < theoretical_finish

      key = [position, round]

      return if Simulation.cached?(key)

      Simulation.cache(key)

      possible_moves.each do |move|
        clone = make_a_clone

        clone.position = move
        clone.round += 1
        clone.round_counter += 1
        clone.path << move

        Simulation.registry(clone)
      end
    end

    def possible_moves
      [
        position,
        [position.first - 1, position.last],
        [position.first + 1, position.last],
        [position.first, position.last - 1],
        [position.first, position.last + 1]
      ].select { |x| map.include?(x) } - map.blizzards_at(round)
    end

    def make_a_clone
      clone = dup

      clone.path = path.deep_dup

      clone
    end
  end

  class Map
    attr_reader :blizzards, :coords, :y_dimension, :x_dimension

    def initialize(input)
      @blizzards_cache = {}
      @y_dimension = input.split("\n").size - 1

      @x_dimension = input.split("\n").first.size - 1

      @coords = input.split("\n").map { |x| x.strip.split('') }

      @blizzards = []
      1.upto(y_dimension - 1).each do |y|
        1.upto(x_dimension - 1).each do |x|
          @blizzards << Blizzard.new(@coords.dig(y, x), [y, x], [y_dimension, x_dimension]) if @coords.dig(y, x) != '.'
        end
      end
    end

    def start
      [0, 1]
    end

    def include?(point)
      point == start ||
        point == finish ||
        ((1..(y_dimension - 1)).include?(point.first) && (1..(x_dimension - 1)).include?(point.last))
    end

    def finish
      [y_dimension, x_dimension - 1]
    end

    def blizzards_at(move)
      @blizzards_cache[move] ||= @blizzards.map { |x| x.position_at(move) }

      @blizzards_cache[move]
    end
  end

  class Blizzard
    def initialize(kind, position, dimensions)
      @kind = kind
      @position = position
      @dimensions = dimensions
    end

    def position_at(move)
      case @kind
      when '>'
        move_right(move)
      when '<'
        move_left(move)
      when '^'
        move_up(move)
      when 'v'
        move_down(move)
      end
    end

    def move_right(move)
      y_position = @position.first
      x_position = @position.last

      move.times do
        x_position += 1
        x_position = 1 if x_position == @dimensions.last
      end

      [y_position, x_position]
    end

    def move_left(move)
      y_position = @position.first
      x_position = @position.last

      move.times do
        x_position -= 1

        x_position = @dimensions.last - 1 if x_position.zero?
      end

      [y_position, x_position]
    end

    def move_down(move)
      y_position = @position.first
      x_position = @position.last

      move.times do
        y_position += 1
        y_position = 1 if y_position == @dimensions.first
      end

      [y_position, x_position]
    end

    def move_up(move)
      y_position = @position.first
      x_position = @position.last

      move.times do
        y_position -= 1
        y_position = @dimensions.first - 1 if y_position.zero?
      end

      [y_position, x_position]
    end
  end
end
