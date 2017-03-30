module Concerns
  module Combat

    def resolve_artillery_combat!
      attacker_pieces_under_fire.each(&:get_captured)
    end

    def attacker_pieces_under_fire
      @attacker_pieces_under_fire ||= active_attacker_pieces.select do |a|
        squares_under_fire.include?({row: a.row, column: a.column})
      end
    end

    def active_attacker_pieces
      pieces.active.where(color: active_player)
    end

    def infantry_all_engaged?
      true
    end
  end
end
