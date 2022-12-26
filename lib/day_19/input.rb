module Day19
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        data(sample).split("\n").map { |x| Blueprint.new(x) }
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end
  end

  class Blueprint # rubocop:disable Metrics/ClassLength
    attr_accessor :resources, :resources_total, :robots, :costs, :step

    def self.registry(simulation)
      index = @simulations.index { |x| x.step == simulation.step }

      @simulations.insert(index || -1, simulation)
    end

    class << self
      attr_reader :simulations
    end

    def self.reset
      @finished = []
      @simulations = []
      @cache = Hash.new { 0 }
    end

    def self.reject(simulation)
      @simulations.delete(simulation)
    end

    def self.save_cache(simulation)
      @cache[simulation.step] = simulation.robo_hash if simulation.robo_hash > @cache[simulation.step]
    end

    def self.identical?(simulation)
      @simulations.find do |x|
        x.object_id != simulation.object_id &&
          x.resources == simulation.resources &&
          x.robots == simulation.robots &&
          x.step == simulation.step
      end
    end

    def self.behind?(simulation)
      @simulations.find do |x|
        x.object_id != simulation.object_id &&
          (x.resources == simulation.resources &&
           x.robots == simulation.robots &&
           x.step == simulation.step) ||
          (x.step <= simulation.step &&
          x.robo_hash - simulation.robo_hash >= weight(simulation))
      end
    end

    def self.weight(simulation)
      case simulation.step
      when 0..10
        30
      when 11..15
        40
      when 15..23
        60
      when 24..32
        60
      end
    end

    def self.iterate(steps)
      loop do
        return @finished.max_by { |x| x.resources[:geode] }.resources[:geode] if @simulations.none?

        sim = @simulations.shift

        if sim.step == steps
          @finished << sim
        else
          sim.simulate_step
        end
      end
    end

    def initialize(line)
      @resources = { ore: 0, clay: 0, obsidian: 0, geode: 0 }
      @resources_total = { ore: 0, clay: 0, obsidian: 0, geode: 0 }
      @robots = { ore: 1, clay: 0, obsidian: 0, geode: 0 }

      @costs = Cost.new(line)
      @step = 0
    end

    def simulate
      self.class.registry(self)
      simulate_step
    end

    def simulate_step
      if self.class.behind?(self)
        self.class.reject(self)
        return
      end

      options = build_robot_options
      increment_resources
      options.each do |option|
        clone = duplicate
        clone.build_robot(option)
        clone.step = @step + 1
        self.class.registry(clone)
        self.class.save_cache(clone)
        clone.calc_robo_hash
      end

      @step += 1

      calc_robo_hash

      self.class.save_cache(self)
      self.class.registry(clone)
    end

    def build_robot_options
      @robots.keys.reverse.select do |key|
        @costs.enough_resources?(key, @resources)
      end
    end

    def build_robot(key)
      @costs.build(key, @resources)
      @robots[key] += 1
    end

    def calc_robo_hash
      @robo_hash = @costs.convert_to_ore(@resources_total)[:ore]
    end

    def robo_hash
      @robo_hash || 0
    end

    def duplicate
      clone = self.clone
      clone.resources = @resources.deep_dup
      clone.resources_total = @resources_total.deep_dup
      clone.robots = @robots.deep_dup

      clone
    end

    def increment_resources
      @resources.merge!(@robots) { |_, old_value, new_value| old_value + new_value }
      @resources_total.merge!(@robots) { |_, old_value, new_value| old_value + new_value }
    end

    def add_robots(robots)
      @robots.merge!(robots) { |_, old_value, new_value| old_value + new_value }
    end
  end

  class Cost
    def initialize(line)
      @ore_robot_cost = { ore: line.match(/Each ore robot costs (\d+) ore./)[1].to_i }

      @clay_robot_cost = { ore: line.match(/Each clay robot costs (\d+) ore./)[1].to_i }

      @obsidian_robot_costs = line.match(/Each obsidian robot costs (\d+) ore and (\d+) clay./)[1..2].map(&:to_i)

      @geode_robot_costs = line.match(/Each geode robot costs (\d+) ore and (\d+) obsidian./)[1..2].map(&:to_i)

      @costs = {
        ore: @ore_robot_cost,
        clay: @clay_robot_cost,
        obsidian: { ore: @obsidian_robot_costs[0], clay: @obsidian_robot_costs[1] },
        geode: { ore: @geode_robot_costs[0], obsidian: @geode_robot_costs[1] }
      }
    end

    def enough_resources?(key, resources)
      @costs[key].all? { |resource, cost| resources[resource] >= cost }
    end

    def build(key, resources)
      @costs[key].each { |resource, cost| resources[resource] -= cost }
    end

    def convert_to_ore(resources)
      accum = resources.deep_dup

      while (accum[:clay]).positive?
        @costs.each do |key, cost|
          next if key == :ore

          accum[key].times do
            accum.merge!(cost) { |_, old_value, new_value| old_value + new_value }
          end
          accum[key] = 0
        end
      end

      accum
    end
  end
end
