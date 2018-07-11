class Character < ApplicationRecord
  has_many :items
  has_many :magic_items
end
