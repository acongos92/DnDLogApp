class CreateCharacterMagicItems < ActiveRecord::Migration[5.0]
  def change
    create_table :character_magic_items do |t|
      t.integer :character_id
      t.integer :magic_item_id
      t.float :applied_td

      t.timestamps
    end
  end
end
