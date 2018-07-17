class Character < ApplicationRecord
  has_many :character_items
  has_many :items, :through => :character_items
  has_many :quests
  has_many :character_magic_items
  has_many :magic_items, :through => :character_magic_items

  validates :name, presence: true
  validates :level, presence: true
  validates :cp, presence: true
  validates :gp, presence: true

  accepts_nested_attributes_for :magic_items
end
