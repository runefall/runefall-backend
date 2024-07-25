class Card < ApplicationRecord
  def self.search(filters)
    cards = Card.all

    filters.each do |filter|
      key, value = filter.first
      cards = cards.where("#{key} ILIKE ?", "%#{value}%")
    end

    cards

    # Card.where('name ILIKE ? AND description ILIKE ?', "%#{filters[:name]}%", "%#{filters[:description]}%")
    # cards = Array.new

    # Card.where('name ILIKE ?', "%#{filters[:name]}%").where('description ILIKE ?', "%#{filters[:description]}%")

    # cards = cards.flatten

    # x = Card.all.reduce([]) do |cards|
    #   require 'pry'; binding.pry
    #   query.each do |k, v|
    #     self.where("#{k} ILIKE ?", "%#{v}%")
    #   end
    # end

    # cards = Card.all
    # final_cards = []
    # filters.each do |filter|
    #   key, value = filter.first
    #   require 'pry'; binding.pry
    #   final_cards = case key
    #   when :description
    #     cards = cards.where('description ILIKE ?', "%#{value}%")
    #   when :name
    #     cards = cards.where('name ILIKE ?', "%#{value}%")
    #   else
    #     # Handle other filters or log an error if needed
    #     # Example: cards = cards.where(key => value)
    #   end
    # end

    # final_cards
  end

  def self.random_cards(limit)
    random_ids = (1..count).to_a.sample(limit)

    cards = where(id: random_ids)

    if limit == 1
      cards.first
    else
      cards
    end
  end
end
