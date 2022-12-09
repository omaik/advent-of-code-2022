module Day8
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      visibles = []
      input.each.with_index do |row, i|
        row.each.with_index do |el, j|
          lines = get_lines(input, i, j)

          next unless lines.any? do |line|
            line.all? { |x| x < el }
          end

          visibles << [i, j]
        end
      end

      visibles.count
    end

    def call2
      visibles = []
      input.each.with_index do |row, i|
        row.each.with_index do |el, j|
          lines = get_lines(input, i, j)

          points = lines.map do |line|
            res = line.each.with_index(1) do |x, index|
              break index if x >= el
            end

            res.is_a?(Integer) ? res : res.size
          end

          visibles << points.inject(:*)
        end
      end

      visibles.max
    end

    def get_lines(input, i, j)
      lines = []

      lines << input[i][0...j].reverse
      lines << input[i][j + 1..]
      lines << input[0...i].map { |x| x[j] }.reverse
      lines << input[i + 1..].map { |x| x[j] }
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
