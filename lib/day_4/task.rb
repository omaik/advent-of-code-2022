module Day4
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      input.select do |line|
        range(line.first).include?(range(line.last)) ||
          range(line.last).include?(range(line.first))
      end.count
    end

    def call2
      input.select do |line|
        (range(line.first).to_a & range(line.last).to_a).any?
      end.count
    end

    def input
      @input ||= Input.call(@sample)
    end

    def range(line)
      array = line.split('-').map(&:to_i)

      array.first..array.last
    end
  end
end
