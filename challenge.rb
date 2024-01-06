# Text-based Game Challenge
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
  
    def perform_move(move)
      puts "#{name} used #{move}!"
      # Add logic for move effects or damage calculations here
    end
  
    def type_effective_against?(opponent)
      case @type
      when "Water"
        return opponent.type == "Fire"
      when "Fire"
        return opponent.type == "Grass"
      when "Grass"
        return opponent.type == "Water"
      else
        return false
      end
    end
  
    def take_damage(amount)
      @current_health -= amount
      @current_health = 0 if @current_health < 0
    end
  
    def fainted?
      @current_health <= 0
    end
  
    def display_health_bar
      health_percentage = (@current_health.to_f / @max_health) * 100
      puts "#{name}'s Health: [#{'=' * (health_percentage / 10)}#{' ' * (10 - health_percentage / 10)}] #{health_percentage}%"
    end
  end
  
  class TextGame
    def initialize
      @player_position = { x: 0, y: 0 }
      @pokemon_encountered = false
      @player_pokemons = []  # Initialize an array to store player's Pokémon
      @player_pokemon = initialize_pokemons.values.first  # Set the player's Pokémon to the first one in the list
    end
  
    def calculate_damage(move, opponent)
        base_damage = 10 # Adjust the base damage based on your game's balancing
      
        if @player_pokemon.type_effective_against?(opponent)
          puts "It's super effective!"
          effective_multiplier = 1.5
        elsif opponent.type_effective_against?(@player_pokemon)
          puts "It's not very effective!"
          effective_multiplier = 0.5
        else
          effective_multiplier = 1.0
        end
      
        type_multiplier = calculate_type_multiplier(move, opponent)
      
        total_damage = (base_damage * effective_multiplier * type_multiplier).to_i
        puts "#{opponent.name} takes #{total_damage} damage."
      
        total_damage
      end
      
      def calculate_type_multiplier(move, opponent)
        # Add logic for type matchups
        case @player_pokemon.type
        when "Fire"
          return 1.5 if opponent.type == "Grass"
          return 0.5 if opponent.type == "Water"
        when "Water"
          # Add logic for Water type matchups
        when "Grass"
          # Add logic for Grass type matchups
        end
      
        # Default type multiplier
        1.0
      end
      
      def initialize_pokemons
        charmander = Pokemon.new("Charmander", "Fire", 100)
        charmander.add_move("Scratch")
        charmander.add_move("Ember")
        charmander.add_move("Tackle")
        charmander.add_move("Growl")
    
        bulbasaur = Pokemon.new("Bulbasaur", "Grass", 100)
        bulbasaur.add_move("Tackle")
        bulbasaur.add_move("Vine Whip")
        bulbasaur.add_move("Growl")
        bulbasaur.add_move("Leech Seed")
    
        squirtle = Pokemon.new("Squirtle", "Water", 100)
        squirtle.add_move("Tackle")
        squirtle.add_move("Bubble")
        squirtle.add_move("Withdraw")
        squirtle.add_move("Tail Whip")
    
        { "Charmander" => charmander, "Bulbasaur" => bulbasaur, "Squirtle" => squirtle }
      end
    
      def display_pokemon_choices
        puts "Choose your Pokémon:"
    
        initialize_pokemons.each_with_index do |(name, pokemon), index|
          puts "#{index + 1}. #{name}"
        end
    
        print "Enter the number of your choice (1-3): "
        choice = gets.chomp.to_i
    
        if choice.between?(1, initialize_pokemons.size)
          @player_pokemon = initialize_pokemons.values[choice - 1]
        else
          puts "Invalid choice. Please choose a valid option."
          display_pokemon_choices
        end
      end
    
      def display_game
        system("clear") || system("cls") # Clear the console screen
    
        # Display player's Pokémon and available moves during battle
        if @player_pokemon && @pokemon_encountered
          puts "Player's Pokémon: #{@player_pokemon.name}"
          @player_pokemon.display_moves
        end
    
        # ASCII art representing the game world
        (0..2).each do |y|
          (0..2).each do |x|
            if @player_position == { x: x, y: y }
              print " P "
            elsif @pokemon_encountered
              print " X "
            else
              print " - "
            end
          end
          puts "\n"
        end
      end
  
    def move_player(direction)
      @pokemon_encountered = false # Reset encounter status
  
      case direction
      when "up"
        @player_position[:y] -= 1 if @player_position[:y] > 0
      when "down"
        @player_position[:y] += 1 if @player_position[:y] < 2
      when "left"
        @player_position[:x] -= 1 if @player_position[:x] > 0
      when "right"
        @player_position[:x] += 1 if @player_position[:x] < 2
      end
  
      # Check for a random encounter
      @pokemon_encountered = true if rand(1..10) <= 2 # 20% chance of encountering a Pokémon
    end
  
    def encounter_menu
        puts "You encountered a wild Pokémon!"
        puts "1. Battle"
        puts "2. Catch"
        puts "3. Run"
        print "Choose an option (1-3): "
    
        choice = gets.chomp.to_i
    
        case choice
        when 1
          battle_menu
        when 2
          catch_menu if @player_pokemon && @pokemon_encountered
        when 3
          puts "You chose to run away from the Pokémon!"
          @pokemon_encountered = false # Reset encounter status
        else
          puts "Invalid choice. Please choose a valid option."
        end
      end
    
      def battle_menu
        opponent = initialize_pokemons.values.sample
        @pokemon_encountered = opponent
        puts "You are battling a wild #{opponent.name}"
      
        loop do
          puts "1. Attack"
          puts "2. Switch Pokémon"
          puts "3. Run"
          puts "4. Catch" if @player_pokemon && @pokemon_encountered
          print "Choose an option (1-4): "
      
          battle_choice = gets.chomp.to_i
      
          case battle_choice
          when 1
            attack_menu(opponent) if opponent
          when 2
            display_pokemon_choices_in_battle
          when 3
            puts "You chose to run away!"
            @pokemon_encountered = false # Reset encounter status
            return # Exit the method instead of using break
          when 4
            catch_menu if @player_pokemon
          else
            puts "Invalid choice. Please choose a valid option."
          end
      
          if @player_pokemon&.fainted?
            puts "#{@player_pokemon.name} fainted!"
            @pokemon_encountered = false # Reset encounter status
            return # Exit the method instead of using break
          end
      
          if opponent&.fainted?
            puts "#{opponent.name} fainted!"
            @pokemon_encountered = false # Reset encounter status
            return # Exit the method instead of using break
          end
      
          opponent_attack(opponent) if opponent.current_health.positive?
      
          if opponent&.fainted?
            puts "#{opponent.name} fainted!"
            @pokemon_encountered = false # Reset encounter status
            return # Exit the method instead of using break
          end
        end
      end
      
    
      def display_pokemon_choices_in_battle
        puts "Switch Pokémon:"
        # Display only the player's captured Pokémon
        unless @player_pokemons.empty?
          @player_pokemons.each_with_index do |pokemon, index|
            puts "#{index + 1}. #{pokemon.name}"
          end
          print "Enter the number of your choice (1-#{@player_pokemons.size}): "
          choice = gets.chomp.to_i
    
          if choice.between?(1, @player_pokemons.size)
            @player_pokemon = @player_pokemons[choice - 1]
          else
            puts "Invalid choice. Please choose a valid option."
            display_pokemon_choices_in_battle
          end
        else
          puts "No Pokémon available. Something went wrong."
        end
      end
     
      def attack_menu(opponent)
        puts "Select a move to use:"
        @player_pokemon.display_moves
      
        move_choice = gets.chomp.to_i
      
        if move_choice.between?(1, @player_pokemon.moves.size)
          move = @player_pokemon.moves[move_choice - 1]
          @player_pokemon.perform_move(move)
      
          damage = calculate_damage(move, opponent)
          opponent.take_damage(damage)
      
          display_battle_status(opponent)
      
          if opponent.fainted?
            puts "#{opponent.name} fainted!"
            @pokemon_encountered = false # Reset encounter status
            return # Use 'return' instead of 'break'
          end
      
          opponent_attack(opponent) if opponent.current_health.positive?
        else
          puts "Invalid move. Please choose a valid move."
          attack_menu(opponent)
        end
      
        if @player_pokemon.fainted?
          puts "#{@player_pokemon.name} fainted!"
          @pokemon_encountered = false # Reset encounter status
          return # Exit the method instead of using break
        end
      
        opponent_attack(opponent) if opponent.current_health.positive?
      
        if @player_pokemon.fainted?
          puts "#{@player_pokemon.name} fainted!"
          @pokemon_encountered = false # Reset encounter status
          return # Exit the method instead of using break
        end
      end
      
  
      def opponent_attack(opponent)
        if @player_pokemon
          damage = calculate_damage(opponent.moves.sample, @player_pokemon)
          @player_pokemon.take_damage(damage)
          puts "#{opponent.name} attacked! #{@player_pokemon.name} takes #{damage} damage."
        else
          puts "#{opponent.name} attacked, but there's no Pokémon to defend!"
        end
      end

  
    def display_battle_status(opponent)
      puts "\nBattle Status:"
      @player_pokemon.display_health_bar
      opponent.display_health_bar
      puts "-------------------"
    end
  
    def catch_menu
        if @pokemon_encountered && @pokemon_encountered.is_a?(Pokemon) && @player_pokemon
          catch_chance = (100 - (@pokemon_encountered.current_health.to_f / @pokemon_encountered.max_health) * 100).to_i
      
          if catch_chance.zero?
            puts "The opponent's health is too high. Can't catch right now."
          else
            puts "Throwing a Poké Ball..."
            sleep(2) # Simulate the catch attempt taking time
      
            if rand(1..100) <= catch_chance
              puts "Congratulations! You caught #{@pokemon_encountered.name}"
      
              # Add the caught Pokémon to the player's team if there is space
              if @player_pokemons.length < 6 && !@player_pokemons.include?(@pokemon_encountered)
                @player_pokemons << @pokemon_encountered
                @player_pokemon = @pokemon_encountered # Set the current Pokémon to the caught one
              elsif @player_pokemons.include?(@pokemon_encountered)
                puts "You already have #{@pokemon_encountered.name} in your team."
                return
              else
                puts "Your team is full. You must release a Pokémon to make room."
                # Optionally, you can implement a release Pokémon feature here
                return
              end
            else
              puts "Oh no! The Pokémon broke free."
            end
          end
        else
          puts "No opponent to catch or you already have a Pokémon. Invalid option."
        end
      end
      
      
      def play
        display_pokemon_choices
        loop do
          display_game
      
          if @pokemon_encountered
            encounter_menu
          elsif @player_pokemon&.fainted?
            puts "Your Pokémon fainted! Game over."
            break
          else
            puts "Enter a direction (up, down, left, right) or 'exit' to quit:"
            user_input = gets.chomp.downcase
      
            break if user_input == 'exit'
      
            move_player(user_input)
          end
        end
      end
    end
      
      
      
  
  # Create an instance of the game and start playing
  game = TextGame.new
  game.play