class CharacterMagicItemsChangeAppliedTdToAppliedTp < ActiveRecord::Migration[5.0]
  def change
    rename_column :character_magic_items, :applied_td, :applied_tp
  end
end
