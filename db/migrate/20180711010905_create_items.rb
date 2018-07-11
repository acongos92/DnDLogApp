class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :name
      t.float :cost
      t.integer :character_id

      t.timestamps
    end
  end
end
