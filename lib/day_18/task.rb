module Day18
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      cubes = input

      cubes.map { |x| (x.face_neighbors - cubes).size }.sum
    end

    def call2
      cubes = input
      x_range = cubes.map(&:x).minmax
      y_range = cubes.map(&:y).minmax
      z_range = cubes.map(&:z).minmax
      candidates = cubes.map { |x| (x.face_neighbors - cubes) }.flatten

      inner = candidates.reject do |candidate|
        candidate.outside?(x_range, y_range, z_range)
      end.map(&:value).uniq.sort.map { |x| Input::Cube.new(x) }

      trapped = inner.select do |candidate|
        trapped?(candidate, x_range, y_range, z_range)
      end

      @excl = []
      excludors = trapped.reject do |candidate|
        @visited = []
        way_out(candidate, x_range, y_range, z_range).tap do |r|
          @excl |= @visited unless r
        end
      end

      (candidates.map(&:value) - excludors.map(&:value)).size
    end

    def input
      @input ||= Input.call(@sample)
    end

    def way_out(candidate, x_range, y_range, z_range)
      return if @excl.include?(candidate)

      (candidate.face_neighbors - input).each do |cand|
        next if @visited.include?(cand)
        return true if cand.outside?(x_range, y_range, z_range)

        @visited << cand

        res = way_out(cand, x_range, y_range, z_range)
        return res if res
      end
      nil
    end

    def trapped?(candidate, x_range, y_range, z_range)
      trapped_x?(candidate, x_range) &&
        trapped_y?(candidate, y_range) &&
        trapped_z?(candidate, z_range)
    end

    def trapped_x?(candidate, range)
      ((range.first)..candidate.x).any? do |x|
        input.include?(Input::Cube.new([x, candidate.y, candidate.z]))
      end && (candidate.x..range.last).any? do |x|
        input.include?(Input::Cube.new([x, candidate.y, candidate.z]))
      end
    end

    def trapped_y?(candidate, range)
      ((range.first)..candidate.y).any? do |y|
        input.include?(Input::Cube.new([candidate.x, y, candidate.z]))
      end && (candidate.y..range.last).any? do |y|
        input.include?(Input::Cube.new([candidate.x, y, candidate.z]))
      end
    end

    def trapped_z?(candidate, range)
      ((range.first)..candidate.z).any? do |z|
        input.include?(Input::Cube.new([candidate.x, candidate.y, z]))
      end && (candidate.z..range.last).any? do |z|
        input.include?(Input::Cube.new([candidate.x, candidate.y, z]))
      end
    end
  end
end
