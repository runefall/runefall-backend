class Card < ApplicationRecord
  def self.search(filters)
    cards = Card.all

    # This searches for cards by name iteratively
    # for each name in the query string
    filters[:name]&.each do |name|
      cards = cards.where(
        "name ILIKE ?",
        "%#{name}%"
      )
    end

    # This uses the ILIKE operator to search by
    # name, description, etc. in a case-insensitive manner
    %i[description rarity artist_name set
       flavor_text card_type].each do |filter|
      next unless filters[filter]

      cards = cards.where(
        "#{filter} ILIKE ?",
        "%#{filters[filter]}%"
      )
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
      values = filters[filter].split(",")
      values.each_with_index do |value, i|
        values[i] = value.strip.split(" ").map(&:capitalize).join(" ")

        # It then changes ["Demacia", "Ionia"] to '"Demacia", "Ionia"'
        # where each value is surrounded by double quotes and separated by commas
        array_text += if i.zero?
                        "\"#{value}\""
                      else
                        ", \"#{value}\""
                      end
      end

      # The array_text string is then used in the SQL query like this:
      # WHERE regions && '{"Demacia", "Ionia"}'
      cards = cards.where(
        "#{key} && ?",
        "{#{array_text}}"
      )
    end

    cards
  end
end
