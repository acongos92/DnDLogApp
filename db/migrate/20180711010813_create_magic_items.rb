class CreateMagicItems < ActiveRecord::Migration[5.0]
  def change
    create_table :magic_items do |t|
      t.string :name
      t.float :tp
      t.integer :character_id

      t.timestamps
    end
  end
end
