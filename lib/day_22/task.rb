module Day22
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      input.perform_moves(sample: @sample)
    end

    def call2
      input.perform_moves(sample: @sample, cubic: true)
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
