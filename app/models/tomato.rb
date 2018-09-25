class Tomato < ApplicationRecord
  has_many :turns

  # Move to yaml file? N, P, and K values on a 0-100 scale taken from 8/32/16 ratio here:
  # https://homeguides.sfgate.com/nitrogen-phosphorus-potassium-concentrations-tomato-plants-66969.html
  def sim_params
    {
      ideal_n: 16.0,
      ideal_p: 64.0,
      ideal_k: 32.0,
      ideal_water: 50.0,
      min_light: 60.0,
      max_light: 90.0,
      min_health_for_growth: 90.0,
      max_health_for_death: 75,
      max_height: 15,
      max_depth: 4
    }
  end

  def most_recent_turn
    turns.count
  end

  def next_turn
    most_recent_turn + 1
  end

  def has_fruit?
    height == sim_params[:max_height]
  end
end
