require "rails_helper"

describe Tomato do
  describe "#has_fruit?" do
    let(:tomato) { Tomato.new }

    it "returns false if it is not at the maximum height" do
      allow(tomato).to receive(:height).and_return(tomato.sim_params[:max_height] - 1)
      expect(tomato.has_fruit?).to be_falsey
    end

    it "returns true if it is not at the maximum height" do
      allow(tomato).to receive(:height).and_return(tomato.sim_params[:max_height])
      expect(tomato.has_fruit?).to be_truthy
    end
  end

  describe "#most_recent_turn" do
    let(:tomato) { Tomato.create!(turns: [Turn.new, Turn.new]) }

    it "returns the number of turns associated with the tomato" do
      expect(tomato.most_recent_turn).to eq 2
    end
  end

  describe "#next_turn" do
    let(:tomato) { Tomato.create!(turns: [Turn.new, Turn.new]) }

    it "returns the number of turns associated with the tomato plus 1" do
      expect(tomato.next_turn).to eq 3
    end
  end
end
