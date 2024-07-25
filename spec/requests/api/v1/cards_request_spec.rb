require 'rails_helper'

RSpec.describe Api::V1::CardsController, type: :request do
  before :each do
    @card = create(:card, id: 1)
    @cards = (2..4).map do |num|
      create(:card, id: num, associated_card_refs: [@card.card_code])
    end
    @card.update(associated_card_refs: @cards.map do |card|
      card.card_code
    end)
  end

  describe 'GET /api/v1/cards/:card_code' do
    it 'returns the card with the specified card_code' do
      get "/api/v1/cards/#{@card.card_code}"

      parsed_card = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_card[:id]).to eq(@card.id.to_s)
      expect(parsed_card[:type]).to eq('card')

      card_attributes = parsed_card[:attributes]

      expect(card_attributes[:name]).to eq(@card.name)
      expect(card_attributes[:card_code]).to eq(@card.card_code)
      expect(card_attributes[:description]).to eq(@card.description)
      expect(card_attributes[:description_raw]).to eq(@card.description_raw)
      expect(card_attributes[:levelup_description]).to eq(@card.levelup_description)
      expect(card_attributes[:levelup_description_raw]).to eq(@card.levelup_description_raw)
      expect(card_attributes[:flavor_text]).to eq(@card.flavor_text)
      expect(card_attributes[:artist_name]).to eq(@card.artist_name)
      expect(card_attributes[:attack]).to eq(@card.attack)
      expect(card_attributes[:cost]).to eq(@card.cost)
      expect(card_attributes[:health]).to eq(@card.health)
      expect(card_attributes[:spell_speed]).to eq(@card.spell_speed)
      expect(card_attributes[:rarity]).to eq(@card.rarity)
      expect(card_attributes[:supertype]).to eq(@card.supertype)
      expect(card_attributes[:card_type]).to eq(@card.card_type)
      expect(card_attributes[:collectible]).to eq(@card.collectible)
      expect(card_attributes[:set]).to eq(@card.set)
      expect(card_attributes[:associated_card_refs]).to eq(@card.associated_card_refs)
      expect(card_attributes[:regions]).to eq(@card.regions)
      expect(card_attributes[:region_refs]).to eq(@card.region_refs)
      expect(card_attributes[:keywords]).to eq(@card.keywords)
      expect(card_attributes[:keyword_refs]).to eq(@card.keyword_refs)
      expect(card_attributes[:formats]).to eq(@card.formats)
      expect(card_attributes[:format_refs]).to eq(@card.format_refs)
      expect(card_attributes[:assets].first[:game_absolute_path]).to eq(@card.assets.first['game_absolute_path'])
      expect(card_attributes[:assets].first[:full_absolute_path]).to eq(@card.assets.first['full_absolute_path'])
      expect(card_attributes[:associated_cards].count).to eq(3)
      expect(card_attributes[:associated_cards].first[:card_code]).to eq(@cards.first.card_code)
      expect(card_attributes[:associated_cards].second[:card_code]).to eq(@cards.second.card_code)
      expect(card_attributes[:associated_cards].third[:card_code]).to eq(@cards.third.card_code)
    end

    it 'returns a not found error if the card with the specified card_code does not exist' do
      get '/api/v1/cards/non_existent_card_code'

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(response.body).to include('Card not found')
    end
  end

  describe 'GET /api/v1/cards' do
    it 'returns all cards' do
      get '/api/v1/cards'

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(response.body).to include(@cards.first.card_code)
      expect(response.body).to include(@cards.second.card_code)
      expect(response.body).to include(@cards.third.card_code)
      expect(response.body).to include(@card.card_code)

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(parsed_cards.count).to eq(4)
      expect(parsed_cards).to be_an(Array)
    end
  end

  describe 'GET /api/v1/cards/search' do
    it 'returns any card that has an partial name match all of the search queries' do
      @card1 = create(:card, name: "Draven")
      @card2 = create(:card, name: "Draven's Whirling Death", description: "whirling axe")
      @card3 = create(:card, name: "Potato", description: "whirling axe")
      create_list(:card, 3, name: "Draven")
      create_list(:card, 3, name: "Draven", description: "axe")

      get "/api/v1/cards/search?query=drav%20description%3aaxe"

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards).to be_an(Array)
      expect(parsed_cards.count).to eq(4)
      expect(response.body).to include(@card2.card_code)
      expect(response.body).to_not include(@card.card_code)
    end

    it 'returns an unsupported query error if an invalid filter is used' do
      get "/api/v1/cards/search?query=drav%20invalid%3aaxe"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.body).to include('Invalid search query')
    end
  end

  describe 'GET /api/v1/cards/random' do
    it 'returns a random card' do
      get "/api/v1/cards/random"

      parsed_card = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_card[:type]).to eq('card')

      card_attributes = parsed_card[:attributes]

      expect(card_attributes).to have_key(:name)
      expect(card_attributes).to have_key(:card_code)
      expect(card_attributes).to have_key(:description)
    end

    it 'accepts a query parameter of limit that lets you return multiple random cards up to the limit' do
      get "/api/v1/cards/random?limit=2"

      parsed_cards = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(parsed_cards.count).to eq(2)

      parsed_cards.each do |card|
        expect(card[:type]).to eq('card')

        card_attributes = card[:attributes]

        expect(card_attributes).to have_key(:name)
        expect(card_attributes).to have_key(:card_code)
        expect(card_attributes).to have_key(:description)
      end
    end
  end
end
