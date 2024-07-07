class CardSerializer
  include JSONAPI::Serializer
  attributes :name,
             :card_code,
             :description,
             :description_raw,
             :levelup_description,
             :levelup_description_raw,
             :flavor_text,
             :artist_name,
             :attack,
             :cost,
             :health,
             :spell_speed,
             :rarity,
             :supertype,
             :card_type,
             :collectible,
             :set,
             :associated_card_refs,
             :regions,
             :region_refs,
             :keywords,
             :keyword_refs,
             :formats,
             :format_refs,
             :assets

  attribute :associated_cards do |object|
    object.associated_card_refs.map do |card|
      Card.find_by(card_code: card)
    end
  end
end
