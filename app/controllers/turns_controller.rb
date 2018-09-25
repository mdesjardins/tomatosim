class TurnsController < ApplicationController
  def new
    @tomato = Tomato.find(params[:id])
    @turn = Turn.new(tomato: @tomato)
    flash[:notice] = "You win!" if @tomato.has_fruit?
  end

  def create
    @tomato = Tomato.find(params[:id])
    @turn = Turn.new(grow_params.merge(tomato: @tomato))

    growth = GreenhouseService.grow(@tomato, grow_params)
    if persist_turn(growth)
      redirect_to new_turn_path(@tomato)
    else
      turn_errors = @turn.errors.full_messages.to_sentence
      tomato_errors = @tomato.errors.full_messages.to_sentence
      flash[:error] = ["Failed to create new turn", turn_errors, tomato_errors].join(", ")
      render :new
    end
  end

  private

  def persist_turn(growth)
    @turn.update_attributes(growth[:turn]) &&
      @tomato.update_attributes(growth[:plant]) &&
      @turn.save &&
      @tomato.save
  end

  def grow_params
    params.require(:turn).permit(:nitrogen, :phosphorus, :potassium, :light, :water)
  end
end
