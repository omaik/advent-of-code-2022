module Day25
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      integer = input.map do |x|
        to_integer(x)
      end.sum

      to_snafu(integer)
    end

    def call2; end

    def input
      @input ||= Input.call(@sample)
    end

    def to_integer(x)
      power = x.size - 1

      power.downto(0).map do |i|
        digit = x.reverse[i]

        digit = '-1' if digit == '-'
        digit = '-2' if digit == '='

        digit.to_i * 5**i
      end.sum
    end

    def to_snafu(integer)
      @digits = []
      power = (0..).detect { |i| 5**i > integer }

      [2, 1].map do |num|
        value = num * 5**power

        to_snafu_rec([num], integer - value, power - 1)
      end

      [2, 1].map do |num|
        value = num * 5**(power - 1)

        to_snafu_rec([num], integer - value, power - 2)
      end

      @digits.first.map do |x|
        {
          0 => '0',
          -1 => '-',
          -2 => '=',
          1 => '1',
          2 => '2'
        }[x]
      end.join
    end

    def to_snafu_rec(nums, integer, power)
      return false if top_num(power) < integer
      return false if (-top_num(power)) > integer
      return false if power.negative?

      p power if rand(1000) == 3

      [2, 1, 0, -1, -2].map do |num|
        value = num * 5**power
        if value == integer
          zeros_count = power
          @digits << [nums, num, Array.new(zeros_count, 0)].flatten
        else
          to_snafu_rec([nums, num].flatten, integer - value, power - 1)
        end
      end
    end

    def top_num(power)
      power.downto(0).map { |i| 2 * 5**i }.sum
    end
  end
end
