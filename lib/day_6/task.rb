module Day6
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      input.each_cons(4).with_index do |cons, i|
        return i + 4 if cons == cons.uniq
      end
    end

    def call2
      input.each_cons(14).with_index do |cons, i|
        return i + 14 if cons == cons.uniq
      end
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
