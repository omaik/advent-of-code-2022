module Day5
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      containers, moves = input

      moves.each do |move|
        move['amount'].to_i.times do
          containers[move['destination'].to_i - 1].unshift(containers[move['source'].to_i - 1].shift)
        end
      end

      containers.map(&:first).join
    end

    def call2
      containers, moves = input

      moves.each do |move|
        containers[move['destination'].to_i - 1].unshift(*containers[move['source'].to_i - 1].shift(move['amount'].to_i))
      end

      containers.map(&:first).join
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
