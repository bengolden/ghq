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
      defender_infantry_engage!
      attacker_infantry_engage!
      # identify_attacker_choices!
      identify_captured_pieces
    end

    def defender_infantry_engage!
      while unengaged_defender_infantry.any?{|di| unengaged_attacker_infantry_adjacent_to(di).count == 1} do
        unengaged_defender_infantry.each do |di|
          adjacent_attacker_infantry = unengaged_attacker_infantry_adjacent_to(di)
          if adjacent_attacker_infantry.count == 1
            di.engaged = adjacent_attacker_infantry.first.id
            adjacent_attacker_infantry.first.engaged = di.id
          end
        end
      end
    end

    def attacker_infantry_engage!
      attacker_infantry_engage_single_infantry!
      attacker_infantry_engage_single_artillery!
    end

    def attacker_infantry_engage_single_infantry!
      while unengaged_attacker_infantry.any?{|di| unengaged_defender_infantry_adjacent_to(di).count == 1} do
        unengaged_attacker_infantry.each do |di|
          adjacent_defender_infantry = unengaged_defender_infantry_adjacent_to(di)
          if adjacent_defender_infantry.count == 1
            di.engaged = adjacent_defender_infantry.first.id
            adjacent_defender_infantry.first.engaged = di.id
          end
        end
      end
    end

    def attacker_infantry_engage_single_artillery!
      while unengaged_attacker_infantry.any?{|di| unengaged_defender_pieces_adjacent_to(di).count == 1} do
        unengaged_attacker_infantry.each do |di|
          adjacent_defender_pieces = unengaged_defender_pieces_adjacent_to(di)
          if adjacent_defender_pieces.count == 1
            di.engaged = adjacent_defender_pieces.first.id
            adjacent_defender_pieces.first.engaged = di.id
          end
        end
      end
    end

    def identify_captured_pieces
      engaged_defender_piece_ids = attacker_infantry.map(&:engaged)
      @captured_pieces += defender_infantry.select do |di|
        engaged_defender_piece_ids.select{|id| id == di.id}.length > 1
      end
      @captured_pieces += defender_pieces.select do |di|
        !di.infantry? && engaged_defender_piece_ids.find{|id| id == di.id}
      end
    end

    def defender_infantry
      defender_pieces.select(&:infantry?)
    end

    def defender_pieces
      @defender_pieces ||= pieces.active.where(color: inactive_player)
    end

    def unengaged_defender_infantry
      defender_infantry.select(&:unengaged?)
    end

    def unengaged_defender_pieces
      defender_pieces.select(&:unengaged?)
    end

    def unengaged_attacker_infantry_adjacent_to(piece)
      unengaged_attacker_infantry.select do |ai|
        adjacent_pieces?(ai, piece)
      end
    end

    def unengaged_defender_infantry_adjacent_to(piece)
      unengaged_defender_infantry.select do |di|
        adjacent_pieces?(di, piece)
      end
    end

    def unengaged_defender_pieces_adjacent_to(piece)
      unengaged_defender_pieces.select do |di|
        adjacent_pieces?(di, piece)
      end
    end

    def adjacent_pieces?(piece1, piece2)
      [piece1.row - piece2.row, piece1.column - piece2.column].map(&:abs).sort == [0, 1]
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
