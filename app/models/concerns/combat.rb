module Concerns
  module Combat

    def resolve_artillery_combat!
      attacker_pieces_under_fire.each(&:get_captured)
    end

    def attacker_pieces_under_fire
      active_attacker_pieces.select do |a|
        squares_under_fire.include?({row: a.row, column: a.column})
      end
    end

    def active_attacker_pieces
      @active_attacker_pierce ||= pieces.active.where(color: active_player)
    end

    def conduct_infantry_combat!
      while unengaged_defender_infantry.any?{|di| unengaged_attacker_infantry_adjacent_to(di).count == 1} do
        unengaged_defender_infantry.each do |di|
          adjacent_attacker_infantry = unengaged_attacker_infantry_adjacent_to(di)
          if adjacent_attacker_infantry.count == 1
            di.engaged = adjacent_attacker_infantry.first.id
            adjacent_attacker_infantry. first.engaged = di.id
          end
        end
      end
      byebug
    end

    def defender_infantry
      @defender_infantry ||= pieces.active.infantry.where(color: inactive_player)
    end

    def unengaged_defender_infantry
      defender_infantry.select(&:unengaged?)
    end

    def unengaged_attacker_infantry_adjacent_to(unit)
      unengaged_attacker_infantry.select do |ai|
        [ai.row - unit.row, ai.column - unit.column].map(&:abs).sort == [0, 1]
      end
    end

    def attacker_infantry
      active_attacker_pieces.select(&:infantry?)
    end

    def unengaged_attacker_infantry
      attacker_infantry.select(&:unengaged?)
    end

    def infantry_all_engaged?
      true
    end
  end
end
