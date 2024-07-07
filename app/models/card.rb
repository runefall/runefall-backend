class Card < ApplicationRecord
  def self.search(filters)
    Card.where('name ILIKE ? AND description ILIKE ?', "%#{filters[:name]}%", "%#{filters[:description]}%")
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
end