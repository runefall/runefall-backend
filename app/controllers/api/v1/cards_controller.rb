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
    query_params = params[:query].split(" ")
    hash = { }
    query_params = query_params.each do |string|
      if string.include?(":")
        filter_array = string.split(":")
        hash[filter_array[0].to_sym] = filter_array[1]
      else
        hash[:name] = string
      end
    end
    hash
  end

  def valid_search_params?
    keys = format_search_params.keys
    keys.all? { |key| permitted_search_criteria.include?(key) }
  end

  def permitted_search_criteria
    [:name, :description]
  end
end
