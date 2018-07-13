class ItemRemoveCharacterFromItem < ActiveRecord::Migration[5.0]
  def change
    remove_column :items, :character_id
  end
end
