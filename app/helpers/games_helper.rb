module GamesHelper

  def square_classes(r,c)
    classes = ""
    classes +=' bottom-row' if r == 7
    classes += (r+c).even? ? ' light' : ' dark'
    classes
  end
end
