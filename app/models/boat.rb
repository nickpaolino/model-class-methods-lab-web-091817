class Boat < ActiveRecord::Base
  belongs_to  :captain
  has_many    :boat_classifications
  has_many    :classifications, through: :boat_classifications

  def self.first_five
    self.first(5)
  end

  def self.dinghy
    dinghy_length_max = 20
    self.where("length < ?", dinghy_length_max)
  end

  def self.ship
    ship_length_min = 20
    self.where("length >= ?", ship_length_min)
  end

  def self.last_three_alphabetically
    self.all.sort_by{|boat| boat.name}.reverse[0..2]
  end

  def self.without_a_captain
    self.all.select {|boat| boat.captain_id == nil}
  end

  def self.sailboats
    sailboat = "Sailboat"
    self.joins(:boat_classifications).joins(:classifications).where("classifications.name = ?", sailboat).uniq
  end

  def self.with_three_classifications
    boats = Boat.joins(:boat_classifications)
    boats.select {|boat| boats.map(&:name).count(boat.name) == 3}.uniq
  end
end

# Creates an array method, pluck, to return an array of object attributes given
# an array of objects
class Array
  def pluck(attribute)
    self.map {|object| object.name}
  end
end
