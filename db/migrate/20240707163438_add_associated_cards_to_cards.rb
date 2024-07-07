class AddAssociatedCardsToCards < ActiveRecord::Migration[7.1]
  def change
    add_column :cards, :associated_cards, :string, array: true, default: []
  end
end
