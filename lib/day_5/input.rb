module Day5
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        containers, moves = data(sample).split("\n\n")
        containers = containers.split("\n").map { |x| x.split(' ') }
        moves = moves.split("\n").map do |move|
          move.match(/move (?<amount>\d+) from (?<source>\d+) to (?<destination>\d+)/)
        end

        [containers, moves]
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end
  end
end
