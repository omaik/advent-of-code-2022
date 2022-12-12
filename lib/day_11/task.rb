module Day11
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      monkeys = input

      20.times do
        monkeys.each { |monkey| monkey.iterate(monkeys, true) }
      end
      monkeys.map(&:inspections).sort.last(2).inject(:*)
    end

    def call2
      monkeys = input

      10_000.times do
        monkeys.each { |monkey| monkey.iterate(monkeys, false) }
      end
      monkeys.map(&:inspections).sort.last(2).inject(:*)
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
