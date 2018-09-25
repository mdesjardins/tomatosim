require "rails_helper"

describe Turn, type: :model do
  it { is_expected.to_not allow_values(-1, 101, 'a').for(:nitrogen) }
  it { is_expected.to_not allow_values(-1, 101, 'a').for(:phosphorus) }
  it { is_expected.to_not allow_values(-1, 101, 'a').for(:potassium) }
  it { is_expected.to_not allow_values(-1, 101, 'a').for(:water) }
  it { is_expected.to_not allow_values(-1, 101, 'a').for(:light) }
end
