class Character < ApplicationRecord
  has_many :character_items
  has_many :items, :through => :character_items
  has_many :quests
  has_many :character_magic_items
  has_many :magic_items, :through => :character_magic_items

  validates :name, presence: true, length: {in: 1 .. 20}
  validates :level, presence: true, numericality: {less_than_or_equal_to: 20}
  validates :race, presence: true, length: {in: 1..20}
  validates :cp, presence: true, numericality: {less_than_or_equal_to: 8}
  validates :gp, presence: true, numericality: {less_than_or_equal_to: 5000000}

  accepts_nested_attributes_for :magic_items
end
