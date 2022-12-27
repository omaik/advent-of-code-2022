module Day16
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        data(sample).split("\n").map do |row|
          Valve.build(row)
        end
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end
  end

  class Valve
    attr_reader :name, :rate

    def self.build(row)
      valve = new(row)

      @valves ||= {}

      @valves[valve.name] = valve
    end

    def self.find(name)
      @valves[name]
    end

    def initialize(row)
      match = row.match(/Valve (\w{2,2}) has flow rate=(\d+); tunnels? leads? to valves? (.*)/)

      @name = match[1]
      @rate = match[2].to_i
      @neighbors = match[3].split(', ')
      @open = false
    end

    def neighbors
      @neighbors.map { |x| self.class.find(x) }
    end

    def open?
      @open
    end


    def open!
      @open = true
    end
  end
end
