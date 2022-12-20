module Day16
  class Day2
    attr_reader :valves

    def initialize(valves)
      @valves = valves
    end

    def call
      Game.play(@valves)
    end
  end

  class Player
    attr_reader :game, :current_valve
    def initialize(game, current_valve=nil)
      @game = game
      @current_valve = current_valve || game.valves.find { |x| x.name == 'AA' }
    end

    def move
      moves = []
      if game.opens.map {|x| x[1] }.exclude?(current_valve) && current_valve.rate.positive?
        moves << 'open'

      else
        @current_valve.neighbors.each do |neighbor|
          moves << neighbor
        end
      end
    end
  end

  class Game
    attr_accessor :step, :valves, :opens, :players

    def self.play(valves)
      @games = []
      @best_moves = Hash.new(-100)
      @finishes = []

      starting_game = Game.new(valves, [])

      starting_game.play

      while @games.size > 0
        game = @games.shift
        p [game.step, game.points]

        game.play
      end
      binding.pry
    end

    def self.duplicate(game, move1, move2)
      new_game = Game.new(game.valves, game.opens.dup, game.step + 1)
      if move1 == 'open'
        return if new_game.opens.map {|x| x[1] }.include?(game.players.first.current_valve)

        new_game.opens << [new_game.step, game.players.first.current_valve]
        player1 = Player.new(new_game, game.players.first.current_valve)
      else
        player1 = Player.new(new_game, move1)
      end

      if move2 == 'open'
        return if new_game.opens.map {|x| x[1] }.include?(game.players.last.current_valve)

        new_game.opens << [new_game.step, game.players.last.current_valve]
        player2 = Player.new(new_game, game.players.last.current_valve)
      else
        player2 = Player.new(new_game, move2)
      end

      @finishes << new_game && return if new_game.step == 12

      new_game.players = [player1, player2]

      if @best_moves[new_game.hash] >= new_game.points
        p ["excluding", new_game.hash, new_game.step, new_game.points]
        return
      else

        @best_moves[new_game.hash] = new_game.points

        @games << new_game
      end
    end

    def initialize(valves, opens, step = 0)
      @opens = opens
      @step = step
      @valves = valves
      @players = [Player.new(self), Player.new(self)]
    end

    def play
      moves1 = players.first.move
      moves2 = players.last.move

      moves1.each do |move1|
        moves2.each do |move2|
          self.class.duplicate(self, move1, move2)
        end
      end
    end


    def points
      @opens.map { |x| x[1].rate * (25 - x[0]) }.sum
    end

    def hash
      [step, 5].max.to_s + "|" + players.map(&:current_valve).map(&:name).join
    end
  end
end
