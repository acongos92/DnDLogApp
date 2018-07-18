class Quest < ApplicationRecord
  belongs_to :character
  validates :name, length: {in: 1..20}
  validates :tp, numericality: { less_than_or_equal_to: 12, greater_than_or_equal_to: 0}
  validates :gp, numericality: { less_than_or_equal_to: 1000, greater_than_or_equal_to: 0}
  validates :cp, numericality: { less_than_or_equal_to: 12, greater_than_or_equal_to: 0}
end
