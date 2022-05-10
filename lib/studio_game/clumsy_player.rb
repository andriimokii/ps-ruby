require_relative 'player'

module StudioGame
    class ClumsyPlayer < Player
        attr_reader :boost_factor
    
        def initialize(name, health=100, boost_factor=1)
            super(name, health)
            @boost_factor = boost_factor
        end
        
        def w00t
            @boost_factor.times { super }
        end
    
        def found_treasure(treasure)
            damaged_treasure = Treasure.new(treasure.name, treasure.points / 2.0)
            super damaged_treasure
            # points = (treasure.points / 2)
            # @found_treasures[treasure.name] += points
    
            # puts "#{@name} found a #{treasure.name}" + 
            #             " worth #{points} points."
            # puts "#{@name}'s treasures: #{@found_treasures}"
            
        end
    end
    
    if __FILE__ == $0
        clumsy = ClumsyPlayer.new("klutz")
    
        hammer = Treasure.new(:hammer, 50)
        clumsy.found_treasure(hammer)
        clumsy.found_treasure(hammer)
        clumsy.found_treasure(hammer)
    
        crowbar = Treasure.new(:crowbar, 400)
        clumsy.found_treasure(crowbar)
    
        clumsy.each_found_treasure do |treasure|
            puts "#{treasure.points} total #{treasure.name} points"
        end
        puts "#{clumsy.points} grand total points"
    end
end
