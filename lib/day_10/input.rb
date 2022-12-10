module Day10
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        data(sample).split("\n").map do |x|
          operation, args = x.split(' ')

          Command.new(operation, args)
        end
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end

    class Command
      attr_reader :operation, :args

      def initialize(operation, args)
        @operation = operation
        @args = args
      end

      def cost
        case operation
        when 'addx'
          2
        when 'noop'
          1
        end
      end

      def execute(context)
        case operation
        when 'addx'
          context.increment(args.to_i)
        when 'noop'
          # noop
        end
      end
    end
  end
end
