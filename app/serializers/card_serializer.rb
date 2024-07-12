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
      Card.find_by(card_code: "#{card}")
    end
  end

  # the below code sends over just the needed card info for assocaiated cards, rather than all attributes
  # attribute :associated_cards do |object|
  #   # Extract associated card references
  #   associated_card_refs = object.associated_card_refs

  #   # Fetch all associated cards in a single query
  #   associated_cards = Card.where(card_code: associated_card_refs)

  #   # Return serialized associated cards
  #   associated_cards.map do |card|
  #     {
  #       id: card.id,
  #       name: card.name,
  #       card_code: card.card_code,
  #       assets: card.assets.gameAbsolutePath
  #       # Include other attributes you need
  #     }
  #   end
  # end
end
