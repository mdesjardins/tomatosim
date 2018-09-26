class TurnsController < ApplicationController
  def new
    @plant = Plant.find(params[:id])
    @turn = Turn.new(plant: @plant)
    flash[:notice] = "You win!" if @plant.has_fruit?
  end

  def create
    @plant = Plant.find(params[:id])
    @turn = Turn.new(grow_params.merge(plant: @plant))

    growth = GreenhouseService.grow(@plant, grow_params)
    if persist_turn(growth)
      redirect_to new_turn_path(@plant)
    else
      turn_errors = @turn.errors.full_messages.to_sentence
      plant_errors = @plant.errors.full_messages.to_sentence
      flash[:error] = ["Failed to create new turn", turn_errors, plant_errors].join(", ")
      render :new
    end
  end

  private

  def persist_turn(growth)
    @turn.update_attributes(growth[:turn]) &&
      @plant.update_attributes(growth[:plant]) &&
      @turn.save &&
      @plant.save
  end

  def grow_params
    params.require(:turn).permit(:nitrogen, :phosphorus, :potassium, :light, :water)
  end
end
