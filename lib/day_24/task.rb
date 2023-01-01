module Day24
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      map = input
      starting_point = map.start
      end_point = map.finish

      Simulation.play(input, starting_point, end_point, 1) - 1
    end


    def call2
      map = input
      starting_point = map.start
      end_point = map.finish

      first_play = Simulation.play(input, starting_point, end_point, 1)

      second_play = Simulation.play(input, end_point, starting_point, first_play)

      Simulation.play(input, starting_point, end_point, second_play) - 1
    end

    def input
      @input ||= Input.call(@sample)
    end
  end
end
