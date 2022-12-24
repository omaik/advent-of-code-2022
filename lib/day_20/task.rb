module Day20
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      numbers = input.dup

      iterate(numbers)

      zero_index = numbers.map(&:value).index(0)
      thousand = numbers[(zero_index + 1000) % numbers.size]
      two = numbers[(zero_index + 2000) % numbers.size]
      three = numbers[(zero_index + 3000) % numbers.size]
      thousand.value + two.value + three.value
    end

    def call2
      input.each do |player|
        player.value *= 811_589_153
      end

      numbers = input.dup

      10.times do
        iterate(numbers)

        numbers.each { |x| x.played = false }
      end

      zero_index = numbers.map(&:value).index(0)
      thousand = numbers[(zero_index + 1000) % numbers.size]
      two = numbers[(zero_index + 2000) % numbers.size]
      three = numbers[(zero_index + 3000) % numbers.size]
      thousand.value + two.value + three.value
    end

    def iterate(numbers)
      loop do
        player = input.find { |x| x.played == false }
        break if player.nil?

        index = numbers.index(player)
        swap(numbers, index, player)
        player.played = true
      end
    end

    def decrease_value(value, size)
      cycles = value / size

      if cycles.positive?
        decrease_value(value % size + cycles, size)
      else
        value
      end
    end

    def swap(numbers, index, player)
      if player.value.positive?
        iterations = decrease_value(player.value, numbers.size)

        iterations.times.inject(index) do |i|
          old_index = in_range(numbers, i)
          new_index = in_range(numbers, i + 1)
          new_index += 1 if new_index.zero?
          numbers.delete_at(old_index)
          numbers.insert(new_index, player)
          new_index
        end
      elsif player.value.negative?
        value = player.value.abs

        iterations = decrease_value(value, numbers.size)

        iterations.times.inject(index) do |i|
          old_index = in_range(numbers, i)
          new_index = in_range(numbers, i - 1)
          new_index -= 1 if [-1, 0].include?(new_index)
          numbers.delete_at(old_index)
          numbers.insert(new_index, player)
          new_index
        end
      end
    end

    def in_range(numbers, number)
      if number >= 0
        if number >= numbers.size
          number - numbers.size
        else
          number
        end
      elsif number.abs >= numbers.size
        number + numbers.size
      else
        number
      end
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
