class DeleteCharacterIdFromItems < ActiveRecord::Migration[5.0]
  def change
    remove_column :magic_items, :character_id
  end
end
