# Text-based Game Challenge
require 'io/console'

class Pokemon
    attr_accessor :name, :type, :moves, :max_health, :current_health
  
    def initialize(name, type, max_health)
      @name = name
      @type = type
      @moves = []
      @max_health = max_health
      @current_health = max_health
    end
  
    def add_move(move)
      @moves << move
    end
  
    def display_moves
      puts "Available Moves for #{name}:"
      @moves.each_with_index { |move, index| puts "#{index + 1}. #{move}" }
    end
  
    def perform_move(move, opponent)
      puts "#{name} used #{move}!"
      damage = 10 + rand(5)  # Example base damage
      damage *= 1.5 if type_effective_against?(opponent)
      damage *= 0.5 if opponent.type_effective_against?(self)
      opponent.take_damage(damage)
    end
  
    def type_effective_against?(opponent)
      case @type
      when "Water"
        opponent.type == "Fire"
      when "Fire"
        opponent.type == "Grass"
      when "Grass"
        opponent.type == "Water"
      else
        false
      end
    end
  
    def take_damage(amount)
      @current_health = [@current_health - amount, 0].max
    end
  
    def fainted?
      @current_health <= 0
    end
  
    def display_health_bar
      health_percentage = (@current_health.to_f / @max_health) * 100
      puts "#{name}'s Health: [#{'=' * (health_percentage / 10)}#{' ' * (10 - health_percentage / 10)}] #{health_percentage}%"
    end
  end


  # Create an instance of the game and start playing
  game = TextGame.new
  game.play