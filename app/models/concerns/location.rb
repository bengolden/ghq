module Location
  extend ActiveSupport::Concern
  def square(row, column)
    return nil unless row && column

    ("A".."H").to_a[column] + (row + 1).to_s
  end
end
