class CreateCharacters < ActiveRecord::Migration[5.0]
  def change
    create_table :characters do |t|
      t.string :name
      t.string :race
      t.integer :level
      t.float :cp
      t.float :gp

      t.timestamps
    end
  end
end
