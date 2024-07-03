class CreateCards < ActiveRecord::Migration[7.1]
  def change
    create_table :cards do |t|
      t.string :name
      t.string :card_code
      t.text :description
      t.text :description_raw
      t.text :levelup_description
      t.text :levelup_description_raw
      t.text :flavor_text
      t.string :artist_name
      t.integer :attack
      t.integer :cost
      t.integer :health
      t.string :spell_speed
      t.string :rarity
      t.string :supertype
      t.string :type
      t.boolean :collectible
      t.string :set

      # Arrays to store lists of strings
      t.string :associated_card_refs, array: true, default: []
      t.string :regions, array: true, default: []
      t.string :region_refs, array: true, default: []
      t.string :keywords, array: true, default: []
      t.string :keyword_refs, array: true, default: []
      t.string :formats, array: true, default: []
      t.string :format_refs, array: true, default: []

      # JSON to store assets
      t.json :assets

      t.timestamps
    end
  end
end
