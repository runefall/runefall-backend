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
    query_params = params[:query].split(" ")
    query_params.map do |string|
      if string.include?(":")
        filter_array = string.split(":")
        { filter_array[0].to_sym => filter_array[1] }
      else
        { name: string }
      end
    end
  end

  def valid_search_params?
    format_search_params.all? do |param|
      key, = param.first
      permitted_search_criteria.include?(key)
    end
  end

  def permitted_search_criteria
    %i[name description]
  end
end
