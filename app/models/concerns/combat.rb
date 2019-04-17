module Concerns
  module Combat
    def resolve_artillery_combat!
      @captured_pieces = attacker_pieces_under_fire
      @captured_pieces.each(&:set_as_captured)
    end

    def attacker_pieces_under_fire
      active_attacker_pieces.select { |a| squares_under_fire.include?(row: a.row, column: a.column) }
    end

    def conduct_infantry_combat
      defender_infantry_engage!
      attacker_infantry_engage!
    end

    def resolve_infantry_combat!
      @captured_pieces += pieces_captured_by_infantry
      @captured_pieces.each(&:set_as_captured)
    end

    def defender_infantry_engage!
      while unengaged_defender_infantry.any? { |di| unengaged_attacker_infantry_adjacent_to(di).count == 1 }
        unengaged_defender_infantry.each do |di|
          adjacent_attacker_infantry = unengaged_attacker_infantry_adjacent_to(di)
          next unless adjacent_attacker_infantry.count == 1

          engagements.create(attacker: adjacent_attacker_infantry.first, defender: di)
        end
      end
    end

    def attacker_infantry_engage!
      attacker_infantry_engage_single_infantry!
      attacker_infantry_engage_single_artillery!
    end

    def attacker_infantry_engage_single_infantry!
      while unengaged_attacker_infantry.any? { |ai| defender_infantry_adjacent_to(ai).count == 1 }
        unengaged_attacker_infantry.each do |ai|
          adjacent_defender_infantry = defender_infantry_adjacent_to(ai)
          next unless adjacent_defender_infantry.count == 1

          engagements.create(attacker: ai, defender: adjacent_defender_infantry.first)
        end
      end
    end

    def attacker_infantry_engage_single_artillery!
      while unengaged_attacker_infantry.any? { |ai| defender_pieces_adjacent_to(ai).count == 1 }
        unengaged_attacker_infantry.each do |ai|
          adjacent_defender_pieces = defender_pieces_adjacent_to(ai)
          next unless adjacent_defender_pieces.count == 1

          engagements.create(attacker: ai, defender: adjacent_defender_pieces.first)
        end
      end
    end

    def active_attacker_pieces
      @active_attacker_pieces ||= pieces.active.where(color: active_player)
    end

    def attacker_infantry
      active_attacker_pieces.select(&:infantry?)
    end

    def unengaged_attacker_infantry
      attacker_infantry.select(&:unengaged?)
    end

    def unengaged_attacker_infantry_adjacent_to(piece)
      unengaged_attacker_infantry.select do |ai|
        adjacent_pieces?(ai, piece)
      end
    end

    def defender_pieces
      @defender_pieces ||= pieces.active.where(color: inactive_player)
    end

    def engaged_defender_piece_ids
      engagements.where(turn_number: turn_number).pluck(:defender_id)
    end

    def defender_infantry
      defender_pieces.select(&:infantry?)
    end

    def captured_infantry
      defender_infantry.select { |di| di.defender_engagements.where(turn_number: turn_number).count > 1 }
    end

    def captured_non_infantry
      defender_pieces.select { |dp| dp.defender_engagements.where(turn_number: turn_number).exists? }
    end

    def pieces_captured_by_infantry
      captured_infantry + captured_non_infantry
    end

    def unengaged_defender_pieces
      defender_pieces.select(&:unengaged?)
    end

    def unengaged_defender_infantry
      defender_infantry.select(&:unengaged?)
    end

    def defender_infantry_adjacent_to(piece)
      defender_infantry.select { |di| adjacent_pieces?(di, piece) }
    end

    def defender_pieces_adjacent_to(piece)
      defender_pieces.select { |di| adjacent_pieces?(di, piece) }
    end

    def adjacent_pieces?(piece1, piece2)
      return false if piece1.nil? || piece2.nil?

      [piece1.row - piece2.row, piece1.column - piece2.column].map(&:abs).sort == [0, 1]
    end

    def infantry_all_engaged?
      true
    end
  end
end
