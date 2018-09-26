class PlantsController < ApplicationController
  def new
    @plant = Plant.new
  end

  def create
    @plant = Plant.new(create_params)
    if @plant.save
      redirect_to new_turn_path(@plant)
    else
      render :new, error: "Failed to create new game: #{@plant.errors.full_messages.to_sentence}"
    end
  end

  private

  def create_params
    params.require(:plant).permit(:name, :plant_type)
  end
end
