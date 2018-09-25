class TomatoesController < ApplicationController
  def new
    @tomato = Tomato.new
  end

  def create
    @tomato = Tomato.new(create_params)
    if @tomato.save
      redirect_to new_turn_path(@tomato)
    else
      render :new, error: "Failed to create new game: #{@tomato.errors.full_messages.to_sentence}"
    end
  end

  private

  def create_params
    params.require(:tomato).permit(:name)
  end
end
