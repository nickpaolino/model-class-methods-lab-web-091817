class Classification < ActiveRecord::Base
  has_many :boat_classifications
  has_many :boats, through: :boat_classifications

  def self.my_all
    self.all
  end

  def self.longest
    longest_boat = Boat.all.sort_by {|boat| boat.length}.reverse.first
    self.joins(:boat_classifications).joins(:boats).where("boats.name = ?", longest_boat.name).uniq
  end
end
