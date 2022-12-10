module Day10
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      cpu = CPU.new
      input.each do |command|
        cpu.execute_command(command)
      end
      cpu.samples.sum
    end

    def call2
      cpu = CPU.new
      input.each do |command|
        cpu.execute_command(command)
      end

      cpu.drawing.each_slice(40).map do |row|
        row.join('')
      end.join("\n")
    end

    def input
      @input ||= Input.call(@sample)
    end
  end

  class CPU
    attr_reader :samples, :drawing

    def initialize
      @clock = 0
      @x = 1
      @samples = []
      @drawing = []
    end

    def execute_command(command)
      command.cost.times do
        draw
        @clock += 1
        sample
      end

      command.execute(self)
    end

    def increment(x)
      @x += x
    end

    def draw
      range = (@x - 1)..(@x + 1)
      @drawing << if range.include?(@clock % 40)
                    '#'
                  else
                    '.'
                  end
    end

    def sample
      return unless (@clock % 40) == 20

      @samples << (@x * @clock)
    end
  end
end
