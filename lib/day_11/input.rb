module Day11
  class Input
    class << self
      INPUT_FILE_PATH = "#{__dir__}/input.txt".freeze
      SAMPLE_INPUT_FILE_PATH = "#{__dir__}/input.sample.txt".freeze

      def call(sample)
        data(sample).split("\n\n").map do |monkey_input|
          Monkey.build(monkey_input)
        end
      end

      def data(sample)
        sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
      end
    end
  end

  Monkey = Struct.new(:starting_items, :operation, :divided_by, :true_throw, :false_throw, :inspections) do
    def self.build(input)
      starting_items = input.match(/Starting items: (.*)/)[1].split(', ').map(&:to_i)
      operation = input.match(/Operation: (.*)/)[1]
      divided_by = input.match(/Test: divisible by (\d+)/)[1].to_i
      true_throw = input.match(/If true: throw to monkey (\d+)/)[1].to_i
      false_throw = input.match(/If false: throw to monkey (\d+)/)[1].to_i

      new(starting_items, operation, divided_by, true_throw, false_throw, 0)
    end

    def iterate(monkeys, decrease_panic)
      starting_items.each do |old|
        self.inspections += 1

        # to fix rubocop (facepalm)
        old.tap {}
        new_item = eval(operation) # rubocop:disable Security/Eval
        new_item /= 3 if decrease_panic
        new_item = new_item % (2 * 3 * 5 * 7 * 11 * 13 * 17 * 19 * 23)

        pass(new_item, monkeys)
      end
      self.starting_items = []
    end

    def pass(item, monkeys)
      if (item % divided_by).zero?
        monkeys[true_throw].receive(item)
      else
        monkeys[false_throw].receive(item)
      end
    end

    def receive(item)
      starting_items << item
    end
  end
end
