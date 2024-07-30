class Card < ApplicationRecord
  def self.search(filters)
    cards = Card.all

    # This searches for cards by name iteratively
    # for each name in the query string
    # filters[:name]&.each do |name|
    #   cards = cards.where(
    #     "name ILIKE ?",
    #     "%#{name}%"
    #   )
    # end
    # This uses the ILIKE operator to search by
    # name, description, etc. in a case-insensitive manner
    %i[name description_raw rarity artist_name set
       flavor_text card_type].each do |filter|
      next unless filters[filter]

      filters[filter]&.each do |value|
        cards = cards.where(
          "#{filter} ILIKE ?",
          "%#{value}%"
        )
      end
    end

    # This uses the && operator to search by region, format, and keyword
    # It searches the string array columns for any of the values
    # contained within the query string, e.g. "Demacia, Ionia" searches
    # for cards that are in either Demacia or Ionia, or both.
    %i[regions formats keywords].each do |filter|
      next unless filters[filter]

      # changes "demacia, ionia" to ["Demacia", "Ionia"]
      # or "quick attack" to ["Quick Attack"]
      array_text = ""

      filters[filter] = filters[filter].map do |value|
        value.split(", ").map do |word|
          word.split(" ").map(&:capitalize).join(" ")
        end
      end

      filters[filter].flatten!

      filters[filter].each_with_index do |value, i|
        capitalized_value = value.strip.split(" ").map(&:capitalize).join(" ")

        # It then changes ["Demacia", "Ionia"] to '"Demacia", "Ionia"'
        # where each value is surrounded by double quotes and separated by commas
        array_text += if i.zero?
                        "\"#{capitalized_value}\""
                      else
                        ", \"#{capitalized_value}\""
                      end
      end

      # The array_text string is then used in the SQL query like this:
      # WHERE regions && '{"Demacia", "Ionia"}'
      cards = cards.where(
        "#{filter} && ?",
        "{#{array_text}}"
      )
    end

    cards
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
