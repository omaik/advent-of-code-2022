module Day9
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      head = Head.new
      tail = Tail.new(head)
      input.each do |line|
        line[:steps].times do
          head.move(line[:direction])
          tail.keep_up
        end
      end

      tail.positions.uniq.size
    end

    def call2
      head = Head.new
      tail1 = Tail.new(head)
      tail2 = Tail.new(tail1)
      tail3 = Tail.new(tail2)
      tail4 = Tail.new(tail3)
      tail5 = Tail.new(tail4)
      tail6 = Tail.new(tail5)
      tail7 = Tail.new(tail6)
      tail8 = Tail.new(tail7)
      tail9 = Tail.new(tail8)

      tails = [tail1, tail2, tail3, tail4, tail5, tail6, tail7, tail8, tail9]

      input.each do |line|
        line[:steps].times do
          head.move(line[:direction])
          tails.each(&:keep_up)
        end
      end

      tail9.positions.uniq.size
    end

    def input
      @input ||= Input.call(@sample)
    end
  end

  class Head
    attr_reader :position

    def initialize
      @position = [0, 0]
    end

    def move(direction)
      case direction
      when 'U'
        position[1] += 1
      when 'L'
        position[0] -= 1
      when 'R'
        position[0] += 1
      when 'D'
        position[1] -= 1
      end
    end
  end

  class Tail
    attr_reader :positions, :head, :position

    def initialize(head)
      @head = head
      @position = [0, 0]
      @positions = [@position]
    end

    def keep_up
      return if adjacent.include?(head.position)

      new_position = [@position[0] + horizontal_move, @position[1] + verical_move]

      @position = new_position
      @positions << new_position
    end

    def horizontal_move
      if head.position[0] > @position[0]
        1
      elsif head.position[0] < @position[0]
        -1
      else
        0
      end
    end

    def verical_move
      if head.position[1] > @position[1]
        1
      elsif head.position[1] < @position[1]
        -1
      else
        0
      end
    end

    def adjacent
      col_index = @position.last
      row_index = @position.first

      [[row_index + 1, col_index],
       [row_index, col_index + 1],
       [row_index, col_index - 1],
       [row_index - 1, col_index],
       [row_index - 1, col_index + 1],
       [row_index + 1, col_index + 1],
       [row_index - 1, col_index - 1],
       [row_index + 1, col_index - 1]]
    end
  end
end
