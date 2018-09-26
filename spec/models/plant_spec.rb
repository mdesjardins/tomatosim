require "rails_helper"

describe Plant do
  describe "#has_fruit?" do
    let(:plant) { Plant.new(plant_type: "tomato") }

    it "returns false if it is not at the maximum height" do
      allow(plant).to receive(:height).and_return(plant.sim_params[:tomato][:max_height] - 1)
      expect(plant.has_fruit?).to be_falsey
    end

    it "returns true if it is not at the maximum height" do
      allow(plant).to receive(:height).and_return(plant.sim_params[:tomato][:max_height])
      expect(plant.has_fruit?).to be_truthy
    end
  end

  describe "#most_recent_turn" do
    let(:plant) { Plant.create!(plant_type: "tomato", turns: [Turn.new, Turn.new]) }

    it "returns the number of turns associated with the plant" do
      expect(plant.most_recent_turn).to eq 2
    end
  end

  describe "#next_turn" do
    let(:plant) { Plant.create!(plant_type: "tomato", turns: [Turn.new, Turn.new]) }

    it "returns the number of turns associated with the plant plus 1" do
      expect(plant.next_turn).to eq 3
    end
  end
end
