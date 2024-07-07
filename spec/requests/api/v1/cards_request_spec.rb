require 'rails_helper'

RSpec.describe Api::V1::CardsController, type: :request do
  before :each do
    @card = create(:card)
    @cards = create_list(:card, 3)
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
end
