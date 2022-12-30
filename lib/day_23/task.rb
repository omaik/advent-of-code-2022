module Day23
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      10.times do
        input.play_round
      end

      input.area
    end

    def call2
      loop do
        input.play_round

        return input.round if input.moved == false
      end
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
