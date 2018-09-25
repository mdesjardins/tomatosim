class Turn < ApplicationRecord
  belongs_to :tomato

  validates :nitrogen, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :phosphorus, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :potassium, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :water, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :light, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
