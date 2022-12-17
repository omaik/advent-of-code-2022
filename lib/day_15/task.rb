module Day15
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      window = @sample ? 20 : 2_000_000
      blacks = input.map do |sensor|
        sensor.black_window(window)
      end.inject(:|)

      beacons = input.map(&:beacon_location)
      blacks -= beacons

      blacks.size
    end

    def call2
      window = @sample ? 20 : 4_000_000
      point = input.map { |x| x.adjacent(input, window) }.flatten(1).uniq.flatten

      (point[0] * 4_000_000) + point[1]
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
