require_relative 'auditable.rb'

module StudioGame
    class Die
        include StudioGame::Auditable
    
        attr_reader :number
    
        def initialize
            roll
        end
    
        def roll
            @number = rand(1..6)
            audit
            @number
        end
    end
end
