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
      render json: { error: "Invalid search query" }, status: :bad_request
    end
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
      /((\w*:".*?"|\w*:\w*)?(\w*:".*?"|\w*:\w*)|\w*)/
    )

    # This hash will store the search parameters
    # Name is initially an empty string because we will
    # use string concatenation to build the name attribute
    attributes = {
      name: ""
    }

    # This loop iterates over the array of arrays
    # and assigns the key-value pairs to the attributes hash.
    # If the key is empty, it appends the value to the name attribute.
    # => {
    #   name: "Draven",
    #   region: "Ionia",
    #   description: "a description here"
    #  }
    attributes_from_query.each do |attr|
      if attr[0].include?(":")
        key, value = attr[0].split(":")
        attributes[key.delete('"').to_sym] = value.delete('"')
      elsif !attr[0].empty?
        attributes[:name] += "#{attr[0]} ".delete('"')
      end
    end

    # This removes the :name key if it is an empty string
    # Otherwise, it deletes any trailing whitespace
    if attributes[:name].empty?
      attributes.delete(:name)
    else
      attributes[:name].rstrip!
    end

    attributes
  end

  def valid_search_params?
    format_search_params.all? do |param|
      key, = param.first
      permitted_search_criteria.include?(key)
    end
  end

  def permitted_search_criteria
    %i[name description type rarity region keyword format artist
       language set flavor_text]
  end
end
