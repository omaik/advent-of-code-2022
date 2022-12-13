module Day13
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      input.filter_map.with_index(1) do |pair, i|
        sorted?(pair) ? i : nil
      end.sum
    end

    def call2
      result = (input + [[[2]], [[6]]]).flatten(1).sort do |x1, x2|
        sorted?([x1.deep_dup, x2.deep_dup]) ? -1 : 1
      end

      (result.index([2]) + 1) * (result.index([6]) + 1)
    end

    def input
      @input ||= Input.call(@sample)
    end

    def sorted?(pair) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      pair = pair.clone
      first, last = pair.map(&:shift)

      return true if first.nil? && !last.nil?
      return false if last.nil? && !first.nil?
      return nil if first.nil? && last.nil?

      if first.is_a?(Integer) && last.is_a?(Integer)
        return false if last < first
        return true if last > first
      else
        result = sorted?([Array(first), Array(last)])
        return false if result == false
        return true if result == true
      end

      sorted?(pair)
    end
  end
end
