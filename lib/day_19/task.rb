module Day19
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      input.each.with_index(1).map do |line, index|
        Blueprint.reset
        line.simulate
        res = Blueprint.iterate(24)

        res * index
      end.sum
    end

    def call2
      input.first(3).map do |line|
        Blueprint.reset
        line.simulate
        Blueprint.iterate(32)
      end.inject(:*)
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
