class MagicItem < ApplicationRecord
  has_many :character_magic_items
  has_many :characters, :through => :character_magic_items
end
