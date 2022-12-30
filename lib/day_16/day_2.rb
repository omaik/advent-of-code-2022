module Day16
  class Day2
    attr_reader :valves

    def initialize(valves)
      @valves = valves
    end

    def call
      sim = Simulation.new(@valves)

      Game.add_simulation(sim)
      Game.play
    end
  end

  class Simulation
    attr_accessor :valves, :minute, :person_valve, :elephant_valve, :open_valves

    def initialize(valves)
      @valves = valves
      @person_valve = valves.find { |x| x.name == 'AA' }
      @elephant_valve = @person_valve
      @open_valves = Hash.new { |h, k| h[k] = [] }
      @minute = 0
    end

    def make_a_copy
      copy = clone

      copy.open_valves = open_valves.deep_dup

      copy
    end

    # Answers -
    #
    def play_minute
      cache_key = [@minute, [person_valve.name, elephant_valve.name].sort].join('-')
      # cache_key = @minute
      if (@minute >= 7 && Cache.get(cache_key) - score >= 0) ||
         (@minute < 7 && Cache.get(cache_key) - score >= 400)

        # puts ["rejected", @minute, score].join(' ')
        return
      end

      if (@valves.map(&:rate).sum - @open_valves.values.flatten.map(&:rate).sum).zero?
        # binding.pry if score > 1706
        Game.finish(self)
        return
      end

      if @minute == 26
        Game.finish(self)
        return
      end

      Cache.add(cache_key, score) if @minute >= 5

      open_person_valve
      visit_person_neighbours
    end

    def score
      @open_valves.map { |minute, valves| (26 - minute) * valves.map(&:rate).sum }.sum
    end

    def open_person_valve
      return if @open_valves.values.flatten.map(&:name).include?(@person_valve.name)
      return if @person_valve.rate.zero?

      person_action = {
        type: :open,
        valve: @person_valve
      }

      play_elephant_actions(person_action)
    end

    def visit_person_neighbours
      @person_valve.neighbors.each do |neighbour|
        play_elephant_actions({
                                type: :visit,
                                valve: neighbour
                              })
      end
    end

    def play_elephant_actions(person_action)
      open_elephant_valve(person_action)

      visit_elephant_neighbours(person_action)
    end

    def open_elephant_valve(person_action)
      return if @open_valves.values.flatten.map(&:name).include?(@elephant_valve.name)
      return if @elephant_valve.rate.zero?
      return if person_action[:type] == :open && @elephant_valve == person_action[:valve]

      elephant_action = {
        type: :open,
        valve: @elephant_valve
      }

      add_simulation(person_action, elephant_action)
    end

    def visit_elephant_neighbours(person_action)
      @elephant_valve.neighbors.each do |neighbour|
        add_simulation(person_action, { type: :visit, valve: neighbour })
      end
    end

    def add_simulation(person_action, elephant_action)
      copy = make_a_copy

      copy.minute += 1

      copy.open_valves[copy.minute] << person_action[:valve] if person_action[:type] == :open
      copy.open_valves[copy.minute] << elephant_action[:valve] if elephant_action[:type] == :open

      copy.person_valve = person_action[:valve]

      copy.elephant_valve = elephant_action[:valve]

      Game.add_simulation(copy)
    end
  end

  class Cache
    class << self
      def add(minute, score)
        @cache ||= Hash.new(-100)

        @cache[minute] = score if @cache[minute] < score
      end

      def get(minute)
        @cache ||= Hash.new(-100)
        @cache[minute]
      end
    end
  end

  class Game
    class << self
      def add_simulation(simulation)
        @simulations ||= []
        @simulations << simulation
      end

      def finish(simulation)
        @finished ||= []

        @finished << simulation
      end

      def play
        loop do
          binding.pry if @simulations.blank?

          x = @simulations.shift

          p [x.minute, @simulations.count] if rand(10_000) == 2

          x.play_minute
        end
      end
    end
  end
end
