module Day21
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      inp = input
      klass = Class.new do
        inp.each do |line|
          define_method line[0] do
            eval(line[1]) # rubocop:disable Security/Eval
          end
        end
      end

      klass.new.root
    end

    def call2
      inp = input
      klass = Class.new do
        inp.each do |line|
          define_method line[0] do
            eval(line[1]) # rubocop:disable Security/Eval
          end
        end
      end
      sample = @sample

      step = sample ? 0 : 3_330_805_295_800

      step.step do |i|
        klass.class_eval do
          define_method 'humn' do
            i
          end

          define_method 'root' do
            if sample
              pppw == sjmn
            else
              bjgs == tjtt
            end
          end
        end

        return i if klass.new.root
      end
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
