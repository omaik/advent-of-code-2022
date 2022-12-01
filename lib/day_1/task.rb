module Day1
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      input.map(&:sum).max
    end

    def call2
      input.map(&:sum).sort.last(3).sum
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
