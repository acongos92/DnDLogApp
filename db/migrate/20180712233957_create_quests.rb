class CreateQuests < ActiveRecord::Migration[5.0]
  def change
    create_table :quests do |t|
      t.string :name
      t.float :tp
      t.float :cp
      t.float :gp
      t.integer :character_id

      t.timestamps
    end
  end
end
