class Card < ApplicationRecord
  def self.search(queries)
    cards = Card.all
    temp_cards = []

    # This populates temp_cards with enough elements
    # To match how many ORs were used in the query
    # So that each can be individually filtered
    (0..(queries.length - 1)).to_a.each do |index|
      temp_cards[index] = cards
    end

    queries.each_with_index do |filters, index|
    # This filters by cost, health, and attack, being either
    # <, >, =, <=, or >= than the value in the query string
    %i[cost health attack].each do |filter|
      next unless filters[filter]

      operator = filters[filter][0]
      value = filters[filter][1]

      case operator
      when :<
        temp_cards[index] = temp_cards[index].where(
          "#{filter} < ?",
          value
        )
      when :>
        temp_cards[index] = temp_cards[index].where(
          "#{filter} > ?",
          value
        )
      when :==
        temp_cards[index] = temp_cards[index].where(
          "#{filter} = ?",
          value
        )
      when :<=
        temp_cards[index] = temp_cards[index].where(
          "#{filter} <= ?",
          value
        )
      when :>=
        temp_cards[index] = temp_cards[index].where(
          "#{filter} >= ?",
          value
        )
      end
    end

      # This uses the ILIKE operator to search by
      # name, description, etc. in a case-insensitive manner
      %i[name description_raw rarity artist_name set flavor_text card_type].each do |filter|
        next unless filters[filter]

        filters[filter]&.each do |value|
          temp_cards[index] = temp_cards[index].where(
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
        temp_cards[index] = temp_cards[index].where(
          "#{filter} && ?",
          "{#{array_text}}"
        )
      end
    end

    temp_cards.reduce { |combined, results| combined.or(results) }
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
