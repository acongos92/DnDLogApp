class Character < ApplicationRecord
  has_many :character_items
  has_many :items, :through => :character_items
  has_many :quests
  has_many :character_magic_items
  has_many :magic_items, :through => :character_magic_items

  accepts_nested_attributes_for :magic_items
end
