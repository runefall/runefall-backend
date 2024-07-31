class Api::V1::CardsController < ApplicationController
  def show
    card = Card.find_by(card_code: params[:card_code])

    if card
      render json: CardSerializer.new(card)
    else
      render json: { error: "Card not found" }, status: :not_found
    end
  end

  def index
    cards = Card.all
    render json: CardSerializer.new(cards)
  end

  def search
    if valid_search_params?
      cards = Card.search(format_search_params)
      render json: CardSerializer.new(cards)
    else
      render json: { error: find_invalid_search_keys },
             status: :bad_request
    end
  end

  def random
    limit = if params[:limit].to_i > 0
              params[:limit].to_i
            else
              1
            end

    cards = Card.random_cards(limit)
    render json: CardSerializer.new(cards)
  end

  private

  def format_search_params
    # This regular expression splits the query string
    # into an array of arrays. Each sub-array contains
    # the key-value pair or a single word.
    # => [
    #   ["region:ionia"],
    #   ['description:"a description here"'],
    #   ["draven"]
    # ]
    attributes_from_query = params[:query].scan(
      /((\w+:".*?"|\w+:\w+)?(\w+:".*?"|\w+:\w+)|\w+)/
    )

    attributes_from_query = attributes_from_query.reduce([]) do |acc, attr|
      acc << attr unless attr[0].nil?
    end

    attributes_from_query.map!(&:uniq!)

    # This hash will store the search parameters
    # Name is initially an empty string because we will
    # use string concatenation to build the name attribute
    attributes = {
      name: []
    }

    # This loop iterates over the array of arrays
    # and assigns the key-value pairs to the attributes hash.
    # If the key is empty, it appends the value to the name attribute.
    # It also removes any double quotes from the key and value.
    # => {
    #   name: ["Draven"],
    #   region: "Ionia",
    #   description: "a description here"
    #  }
    attributes_from_query.each do |attr|
      if attr[0].include?(":")
        key, value = attr[0].split(":")
        key_symbol = key.delete('"').to_sym

        if attributes[key_symbol]
          attributes[key_symbol] << value.delete('"').strip
        else
          attributes[key_symbol] = [value.delete('"').strip]
        end
      elsif !attr[0].empty?
        attributes[:name] << attr[0].delete('"').strip
      end
    end

    # This removes the :name key if it is an empty string
    # Otherwise, it deletes any trailing whitespace
    attributes.delete(:name) if attributes[:name] == []

    reassign_keys(attributes)

    attributes
  end

  def find_invalid_search_keys
    invalid_keys = []
    format_search_params.each do |param|
      key, = param.first
      invalid_keys << key unless permitted_search_criteria.include?(key)
    end
    invalid_text = invalid_keys.join(", ")
    if invalid_keys.length > 1
      "[#{invalid_text}] are invalid search queries"
    else
      "#{invalid_text} is an invalid search query"
    end
  end

  def reassign_keys(attributes)
    [
      %i[d description],
      %i[t card_type],
      %i[r rarity],
      %i[type card_type],
      %i[reg regions],
      %i[k keywords],
      %i[f formats],
      %i[s set],
      %i[ft flavor_text],
      %i[a artist_name],
      %i[region regions],
      %i[format formats],
      %i[keyword keywords],
      %i[artist artist_name]
    ].each do |key, new_key|
      attributes[new_key] = attributes.delete(key) if attributes.key?(key)
    end
  end

  def valid_search_params?
    format_search_params.all? do |param|
      key, = param.first
      permitted_search_criteria.include?(key)
    end
  end

  def permitted_search_criteria
    %i[name description card_type rarity regions keywords formats artist_name
       set flavor_text]
  end
end
