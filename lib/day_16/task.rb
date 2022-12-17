module Day16
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      input
      starting = Valve.find('AA')

      @visits = []

      @finishes = []

      @best_ways = Hash.new(-100)

      starting.neighbors.each do |neighbor|
        @visits << [neighbor, [starting.name], [], 0]
      end

      visit

      @finishes.max_by { |x| x[3] }[3]
    end

    def call2; end

    def input
      @input ||= Input.call(@sample)
    end

    private

    def visit # rubocop:disable Metrics/CyclomaticComplexity
      loop do
        valve, depth, opens, size = @visits.shift
        return if valve.nil?

        puts "Queue #{@visits.size}}" if rand(1000) == 3

        old_size = @best_ways["#{[depth.size, 5].max}#{opens.size}#{valve.name}"]

        if size <= old_size
          p ['rejected', valve.name, depth, opens, size]
          next
        end

        @best_ways["#{[depth.size, 5].max}#{opens.size}#{valve.name}"] = size

        if depth.size + opens.size >= 30
          @finishes << [valve, depth, opens, size]
          next
        end

        if opens.exclude?(valve.name) && valve.rate.positive?
          new_size = size + valve.rate * ((29 - depth.size - opens.size))

          insert_visit(valve, depth, opens + [valve.name], new_size)

        end

        valve.neighbors.each do |neighbor|
          insert_visit(neighbor, depth + [valve.name], opens, size)
        end
      end
    end

    def insert_visit(valve, depth, opens, size)
      @visits << [valve, depth, opens, size]
    end
  end
end
