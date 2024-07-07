require "faker"

FactoryBot.define do
  factory :card do
    name { Faker::Games::LeagueOfLegends.champion }
    card_code { Faker::Alphanumeric.alphanumeric(number: 10).upcase }
    description { Faker::Lorem.sentence }
    description_raw { Faker::Lorem.sentence }
    levelup_description { Faker::Lorem.sentence }
    levelup_description_raw { Faker::Lorem.sentence }
    flavor_text { Faker::Lorem.sentence }
    artist_name { Faker::Artist.name }
    attack { Faker::Number.between(from: 0, to: 10) }
    cost { Faker::Number.between(from: 0, to: 10) }
    health { Faker::Number.between(from: 0, to: 10) }
    spell_speed { %w[Fast Slow Burst].sample }
    rarity { %w[Common Rare Epic Legendary].sample }
    supertype { %w[Champion Follower Spell].sample }
    card_type { %w[Unit Spell Landmark].sample }
    collectible { Faker::Boolean.boolean }
    set { Faker::Number.between(from: 1, to: 5).to_s }
    associated_card_refs { Array.new(3) { Faker::Alphanumeric.alphanumeric(number: 10).upcase } }
    regions { Array.new(2) { Faker::Games::LeagueOfLegends.location } }
    region_refs { Array.new(2) { Faker::Games::LeagueOfLegends.location } }
    keywords { Array.new(3) { Faker::Lorem.word } }
    keyword_refs { Array.new(3) { Faker::Lorem.word } }
    formats { Array.new(2) { %w[Standard Eternal].sample } }
    format_refs { Array.new(2) { %w[client_Formats_Standard_name client_Formats_Eternal_name].sample } }
    assets do
      [
        {
          "gameAbsolutePath" => Faker::Internet.url,
          "fullAbsolutePath" => Faker::Internet.url
        }
      ]
    end
  end
end
