# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "json"

Card.destroy_all

set_1_json = JSON.parse(File.read("db/data/set1.json"), symbolize_names: true)
set_2_json = JSON.parse(File.read("db/data/set2.json"), symbolize_names: true)
set_3_json = JSON.parse(File.read("db/data/set3.json"), symbolize_names: true)
set_4_json = JSON.parse(File.read("db/data/set4.json"), symbolize_names: true)
set_5_json = JSON.parse(File.read("db/data/set5.json"), symbolize_names: true)
set_6_json = JSON.parse(File.read("db/data/set6.json"), symbolize_names: true)
set_6cde_json = JSON.parse(
  File.read("db/data/set6cde.json"),
  symbolize_names: true
)
set_7_json = JSON.parse(File.read("db/data/set7.json"), symbolize_names: true)
set_7b_json = JSON.parse(File.read("db/data/set7b.json"), symbolize_names: true)
set_8_json = JSON.parse(File.read("db/data/set8.json"), symbolize_names: true)
set_9_json = JSON.parse(File.read("db/data/set9.json"), symbolize_names: true)

sets = [
  set_1_json,
  set_2_json,
  set_3_json,
  set_4_json,
  set_5_json,
  set_6_json,
  set_6cde_json,
  set_7_json,
  set_7b_json,
  set_8_json,
  set_9_json
]

sets.each do |set|
  set.each do |card|
    card[:assets] = [{
      game_absolute_path: card[:assets].first[:gameAbsolutePath],
      full_absolute_path: card[:assets].first[:fullAbsolutePath]
    }]

    card[:regions] = card[:regions].reduce([]) do |acc, region|
      acc << if region == "Piltover & Zaun"
               "Piltover And Zaun"
             else
               region
             end
    end

    Card.create!(
      name: card[:name],
      card_code: card[:cardCode],
      description: card[:description],
      description_raw: card[:descriptionRaw],
      levelup_description: card[:levelupDescription],
      levelup_description_raw: card[:levelupDescriptionRaw],
      flavor_text: card[:flavorText],
      artist_name: card[:artistName],
      attack: card[:attack],
      cost: card[:cost],
      health: card[:health],
      spell_speed: card[:spellSpeed],
      rarity: card[:rarity],
      supertype: card[:supertype],
      card_type: card[:type],
      collectible: card[:collectible],
      set: card[:set],
      associated_card_refs: card[:associatedCardRefs],
      regions: card[:regions],
      region_refs: card[:regionRefs],
      keywords: card[:keywords],
      keyword_refs: card[:keywordRefs],
      formats: card[:formats],
      format_refs: card[:formatRefs],
      assets: card[:assets]
    )
  end
end
