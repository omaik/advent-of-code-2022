module Day3
  class Task
    POINTS = ('a'..'z').to_a + ('A'..'Z').to_a

    def initialize(sample)
      @sample = sample
    end

    def call1
      input.map do |line|
        size = line.size
        line = [line.slice(0, size / 2), line.slice((size / 2), size / 2)]
        union = line[0].chars & line[1].chars

        POINTS.index(union.first) + 1
      end.sum
    end

    def call2
      input.each_slice(3).map do |lines|
        lines = lines.map(&:chars)
        union = lines.inject(:&)

        POINTS.index(union.first) + 1
      end.sum
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
