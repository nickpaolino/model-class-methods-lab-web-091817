class Captain < ActiveRecord::Base
  has_many :boats

  def self.catamaran_operators
    catamaran_id = Classification.find_by(name: "Catamaran").id
    catamaran_boats = BoatClassification.where("classification_id = ?", catamaran_id)
    boats = catamaran_boats.map(&:boat_id).map{|boat_id| Boat.find(boat_id)}
    boats.map(&:captain_id).map{|captain_id| self.find(captain_id)}
  end

  def self.sailors
    sailboat_captain_ids = Boat.sailboats.map(&:captain_id).compact
    sailboat_captain_ids.map{|captain_id| self.find(captain_id)}.uniq
  end

  def self.talented_seamen
    # These are sailors who have sailed a motorboat and sailboat
    sailboat, motorboat = "Sailboat", "Motorboat"
    sailboat = Boat.joins(:boat_classifications).joins(:classifications).where("classifications.name = ?", sailboat)
    motorboat = Boat.joins(:boat_classifications).joins(:classifications).where("classifications.name = ?", motorboat)
    sailboat_motorboat = sailboat.select {|sailboat| motorboat.map(&:captain_id).include?(sailboat.captain_id)}
    captain_ids = sailboat_motorboat.map(&:captain_id).uniq
    captain_ids.map {|captain_id| self.find(captain_id)}
  end

  def self.non_sailors
    self.select {|captain| !self.sailors.include?(captain)}
  end

end
