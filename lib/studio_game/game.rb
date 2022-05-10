require_relative 'player'
require_relative 'die'
require_relative 'game_turn'
require_relative 'treasure_trove'
require 'csv'

module StudioGame
    class Game
        attr_reader :title
    
        def initialize(title)
            @title = title
            @players = []
        end
    
        def load_players(from_file)
    
            CSV.foreach(from_file) do |line|
                player = Player.new(line[0], Integer(line[1]))
                add_player(player)
            end
            
            # we have it in tests, but do not use
            # File.readlines(from_file).each do |line|
            #     player = Player.from_csv(line)
            #     add_player(player)
            # end
        end
    
        def save_high_scores(to_file='high_scores.txt')
            File.open(to_file, 'w') do |file|
                file.puts "#{@title} High Scores:"
                @players.sort.each do |player|
                    file.puts high_score_entry(player)
                end
            end
        end
    
        def high_score_entry(player)
            "#{player.name.ljust(30, '.')}" + " #{player.score}"
        end
    
        def add_player(player)
            @players << player
        end
    
        def play(rounds)
            puts "There are #{@players.size} players in #{@title}:"
            puts @players
    
            treasures = TreasureTrove::TREASURES
            puts "\nThere are #{treasures.size} treasures to be found:"
            treasures.each do |treasure|
                puts "A #{treasure.name} is worth #{treasure.points} points"
            end
    
            1.upto(rounds) do |round|
                if block_given?
                    break if yield
                end
                
                puts "\nRounds ##{round}"
                @players.each do |player|
                    GameTurn.take_turn(player)
    
                    #puts player
                end
            end
        end
    
        def print_name_and_health(player)
            puts "#{player.name} (#{player.health})"
        end
    
        def print_stats
            strong_players, wimpy_players = 
                @players.partition { |player| player.strong? }
            
            puts "Knuckleheads Statistics:"
    
            puts "\n#{strong_players.length} strong players:"
            strong_players.each do |player|
                print_name_and_health(player)
            end
    
            puts "\n#{wimpy_players.length} wimpy players:"
            wimpy_players.each do |player|
                print_name_and_health(player)
            end
            
            @players.each do |player|
                puts "\n#{player.name}'s point totals:\n#{player.points} grand total points"
            end
    
            puts "\n#{@title} High Scores:"
            @players.sort.each do |player|
                puts high_score_entry(player)
            end
    
            puts "\n#{total_points} total points from treasures found"
    
            @players.sort.each do |player|
                puts "\n#{player.name}'s point totals:"
                player.each_found_treasure do |treasure|
                    puts "#{treasure.points} total #{treasure.name} points"
                end
                puts "#{player.points} grand total points"
            end
    
        end
    
        def total_points
            @players.reduce(0) { |sum, player| sum + player.points }
        end
        
    end
end
