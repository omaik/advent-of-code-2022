module Day3
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1; end

    def call2; end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
