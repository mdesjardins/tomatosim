require 'rails_helper'

# I normally wouldn't test this many private methods because it'd make
# more sense to not go into the internals of the service, but there's
# so much math in this it kinda made sense to go ahead and test the
# private methods.
#
describe GreenhouseService do
  describe "#new_nutrient_level" do
    let(:greenhouse) { GreenhouseService.new({}, @turns, {}, {}) }

    context "when starting with no turns" do
      it "should  return the new value" do
        @turns = []
        expect(greenhouse.send(:new_nutrient_level, :nitrogen, 10)).to eq(10)
      end
    end

    context "when there is prior history" do
      it "should calculate the halflife with one previous value" do
        @turns = [
          { id: 1, "nitrogen" => 10 }
        ]
        expect(greenhouse.send(:new_nutrient_level, :nitrogen, 10)).to eq(15)
      end

      it "should calculate the halflife with two previous values" do
        @turns = [
          { id: 1, "nitrogen" => 10 },   # 2.5 left by 3rd turn
          { id: 2, "nitrogen" => 10 }    # 5.0 left by 3rd turn
        ]
        # 10 + 5 + 2.5 = 17.5
        expect(greenhouse.send(:new_nutrient_level, :nitrogen, 10)).to eq(17.5)
      end

      it "should calculate the halflife with three previous values" do
        @turns = [
          { id: 1, "nitrogen" => 20 },   # 2.5 left by 4th turn
          { id: 2, "nitrogen" => 10 },   # 2.5 left by 4rd turn
          { id: 3, "nitrogen" => 5 }     # 2.5 left by 4th turn
        ]
        # 10 + 2.5 + 2.5 + 2.5 = 17.5
        expect(greenhouse.send(:new_nutrient_level, :nitrogen, 10)).to eq(17.5)
      end

      it "should work when adding zero on the current turn" do
        @turns = [
          { id: 1, "nitrogen" => 20 },   # 2.5 left by 4th turn
          { id: 2, "nitrogen" => 10 },   # 2.5 left by 4rd turn
          { id: 3, "nitrogen" => 5 }     # 2.5 left by 4th turn
        ]
        # 10 + 2.5 + 2.5 + 2.5 = 17.5
        expect(greenhouse.send(:new_nutrient_level, :nitrogen, 0)).to eq(7.5)
      end

      it "should work when zero was added on a previous turn" do
        @turns = [
          { id: 1, "nitrogen" => 20 },  # 2.5 left by 4th turn
          { id: 2, "nitrogen" => 0 },   # 0
          { id: 3, "nitrogen" => 5 }   # 2.5 left by 4th turn
        ]
        # 10 + 2.5 + 2.5 = 15.0
        expect(greenhouse.send(:new_nutrient_level, :nitrogen, 10)).to eq(15.0)
      end
    end
  end

  describe "#new_root_depth" do
    let(:sim_params) do
      {
        min_health_for_growth: 90,
        max_health_for_death: 75,
        max_depth: 5
      }
    end

    let(:greenhouse) { GreenhouseService.new(@tomato, [], sim_params, {}) }

    context "when root health is less than the variance" do
      it "should increase the depth" do
        @tomato = { "depth" => 3 }
        allow(greenhouse).to receive(:new_root_health).
          and_return(91)
        expect(greenhouse.send(:new_depth)).to eq 4
      end
    end

    context "when root health is more than the variance" do
      it "should decrease the depth" do
        @tomato = { "depth" => 3 }
        allow(greenhouse).to receive(:new_root_health).
          and_return(74)
        expect(greenhouse.send(:new_depth)).to eq 2
      end
    end
  end

  describe "#new_plant_height" do
    let(:sim_params) do
      {
        min_health_for_growth: 90,
        max_health_for_death: 75,
        max_height: 15
      }
    end

    let(:greenhouse) { GreenhouseService.new(@tomato, [], sim_params, {}) }

    context "when plant health is less than the variance" do
      it "should increase the depth" do
        @tomato = { "height" => 10 }
        allow(greenhouse).to receive(:new_plant_health)
          .and_return(91)
        allow(greenhouse).to receive(:acceptable_light?).and_return(true)
        expect(greenhouse.send(:new_height)).to eq 11
      end
    end

    context "when plant health is more than the variance" do
      it "should decrease the depth" do
        @tomato = { "height" => 10 }
        allow(greenhouse).to receive(:new_plant_health)
          .and_return(74)
        allow(greenhouse).to receive(:acceptable_light?).and_return(true)
        expect(greenhouse.send(:new_height)).to eq 9
      end
    end
  end

  describe "#accumulated_variance_from_ideal" do
    let(:greenhouse) { GreenhouseService.new({}, [], {}, {}) }

    it "should return a result of 50 vs. ideal 25 a 100.0 percentage from ideal" do
      allow(greenhouse).to receive(:new_nutrient_level).and_return(50)
      expect(greenhouse.send(:accumulated_variance_from_ideal, :nitrogen, 50, 25)).to eq 100
    end

    it "should return a result of 50 vs. ideal 50 a 0.0 percentage from ideal" do
      allow(greenhouse).to receive(:new_nutrient_level).and_return(50)
      expect(greenhouse.send(:accumulated_variance_from_ideal, :nitrogen, 50, 50)).to eq 0
    end
  end

  describe "#acceptable_light?" do
    let(:sim_params) do
      {
        min_light: 60,
        max_light: 90
      }
    end
    let(:greenhouse) { GreenhouseService.new({}, [], sim_params, { light: @light }) }

    it "should return false if the amount if light is less than the minimum" do
      @light = 59
      expect(greenhouse.send(:acceptable_light?)).to be_falsey
    end

    it "should return false if the amount if light is more than the maximum" do
      @light = 91
      expect(greenhouse.send(:acceptable_light?)).to be_falsey
    end

    it "should return true if the amount if light more than the minimum and is less than the maximum" do
      @light = 61
      expect(greenhouse.send(:acceptable_light?)).to be_truthy
      @light = 89
      expect(greenhouse.send(:acceptable_light?)).to be_truthy
    end
  end
end
