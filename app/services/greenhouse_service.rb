#
# A plant's growth progresses from 0-15.
# Root health is expressed in 0-4.
#
# The simulator works like this:
# 1) Plant health is controlled by Nitrogen, Potassium, and Water levels.
# 2) Root health is controlled by Phosphorus levels.
# 3) Nitrogen, Potassium, Phosphorus, and Water all have different half-lifes
#    which control the rate that each nutrient dissipates from the environment.
# 4) Light does not dissipate and is modeled more simply than the other
#    nutrients; it only needs to be between the minimum and maximum values
#    for them plant. If there is an unacceptable level of light, the plant
#    will not grow.
# 5) Plants have an ideal level of Nitrogen, Potassium, Phosphorus, and
#    Water levels, on a scale of 0-100. Each plant has what is effectively
#    a "fussiness factor" that is controlled by a min_health_for_growth and
#    a max_health_for_death. For roots, if the phosphorus level is between
#    the min and max percentage from ideal, the roots will grow. For the plant,
#    the nitrogen, potassium, and water level's difference from ideal is
#    summed, i.e. the percentage variance from ideal for all three has to be
#    within the min/max of the plant tolerance to grow.
#
# You should be able to test this thing without ActiveRecord if you instantiate
# it directly and call the grow instance method. If you want to construct one
# of these from an ActiveRecord object (which is probably what you'll want
# to do most of the time), you can do so using the grow class method.
#
# The grow instance method returns a hash that describes the overall health of
# the plant as well as the accumulated nutrient levels.
#
class GreenhouseService
  # Simulation parameters
  NUTRIENT_MAX = 100.0
  HALF_LIFE = {
    nitrogen: 1.0,
    potassium: 2.0,
    phosphorus: 3.0,
    water: 0.5
  }

  def self.grow(plant, new_nutrients)
    # After calling this, we aren't depending on ActiveRecord anymore.
    plant_attributes = plant.attributes
    turns_attributes = plant.turns.order(:id).map(&:attributes)
    new(plant_attributes, turns_attributes, plant.sim_params[plant.plant_type.to_sym], new_nutrients).grow
  end

  def initialize(plant, turns, sim_params, turn_params)
    @plant = plant
    @turns = turns
    @sim_params = OpenStruct.new(sim_params)

    @nitrogen = turn_params[:nitrogen].to_f
    @phosphorus = turn_params[:phosphorus].to_f
    @potassium = turn_params[:potassium].to_f
    @water = turn_params[:water].to_f
    @light = turn_params[:light].to_i
  end

  def grow
    {
      plant: {
        plant_health: new_plant_health,
        root_health: new_root_health,
        height: new_height,
        depth: new_depth
      },
      turn: {
        accum_nitrogen: new_nutrient_level(:nitrogen, @nitrogen),
        accum_phosphorus: new_nutrient_level(:phosphorus, @phosphorus),
        accum_potassium: new_nutrient_level(:potassium, @potassium),
        accum_water: new_nutrient_level(:water, @water)
      }
    }
  end

  private

  def new_nutrient_level(nutrient, amount_added)
    result = amount_added

    @turns.each_with_index do |turn, index|
      #
      # The formula for half life is:
      #
      #                 number or turns
      #                 |
      #                 V
      #                 t/h <--- half life
      # N(t) = N(0)(0.5)
      #  ^      ^
      #  |      |
      #  |      Initial Amount
      #  New Amount
      #
      # See https://www.wikihow.com/Calculate-Half-Life
      #
      turns_ago = @turns.length - index
      added = turn[nutrient.to_s].to_f
      remaining = added * (0.5**(turns_ago.to_f / HALF_LIFE[nutrient]))
      result += remaining
    end
    result.clamp(0, NUTRIENT_MAX)
  end

  def accumulated_variance_from_ideal(nutrient_name, amount_added, ideal_level)
    (1.0 - new_nutrient_level(nutrient_name, amount_added) / ideal_level).abs * 100.0
  end

  # Plant health is a function of current water, nitrogen, and potassium levels.
  # "Health" is a number between 0 and 100. 100 = ideal conditions for growth.
  def new_plant_health
    nitrogen = accumulated_variance_from_ideal(:nitrogen, @nitrogen, @sim_params.ideal_n)
    potassium = accumulated_variance_from_ideal(:potassium, @potassium, @sim_params.ideal_k)
    water = accumulated_variance_from_ideal(:water, @water, @sim_params.ideal_water)

    (100.0 - [nitrogen, potassium, water].sum).clamp(0, 100)
  end

  # Root health is a function of current phosphorus levels
  def new_root_health
    (100.0 - accumulated_variance_from_ideal(:phosphorus, @phosphorus, @sim_params.ideal_p)).clamp(0, 100)
  end

  def acceptable_light?
    @light > @sim_params.min_light && @light < @sim_params.max_light
  end

  def new_height
    result = @plant["height"]
    return result unless acceptable_light?
    result += 1 if new_plant_health > @sim_params.min_health_for_growth
    result -= 1 if new_plant_health < @sim_params.max_health_for_death
    result.clamp(0, @sim_params.max_height)
  end

  def new_depth
    result = @plant["depth"]
    result += 1 if new_root_health > @sim_params.min_health_for_growth
    result -= 1 if new_root_health < @sim_params.max_health_for_death
    result.clamp(0, @sim_params.max_depth)
  end
end
