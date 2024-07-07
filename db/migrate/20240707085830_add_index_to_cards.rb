class AddIndexToCards < ActiveRecord::Migration[7.1]
  def change
    add_index :cards, :card_code, unique: true
  end
end
