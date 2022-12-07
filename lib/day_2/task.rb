module Day2
  class Task
    MAP = {
      'X' => 'A',
      'Y' => 'B',
      'Z' => 'C'
    }.freeze

    SCORES = {
      'A' => 1,
      'B' => 2,
      'C' => 3
    }.freeze

    ORDER = SCORES.keys

    def initialize(sample)
      @sample = sample
    end

    def call1
      input.map do |row|
        row[1] = MAP[row[1]]
        calculate_points(row)
      end.sum
    end

    def call2
      input.map do |row|
        case row[1]
        when 'X'
          row[1] = ORDER[ORDER.index(row[0]) - 1]
        when 'Y'
          row[1] = row[0]
        when 'Z'
          row[1] = ORDER[(ORDER.index(row[0]) + 1) % 3]
        end
        calculate_points(row)
      end.sum
    end

    def input
      @input ||= Input.call(@sample)
    end

    def calculate_points(row)
      point_for_selection = SCORES[row[1]]
      point_for_win = point_for_win(row)
      point_for_selection + point_for_win
    end

    def point_for_win(row)
      return 3 if row[0] == row[1]
      return 6 if ORDER.index(row[1]) == (ORDER.index(row[0]) + 1) % 3

      0
    end
  end
end
